#!/usr/bin/env bash

# Ensure we're running in bash
if [ -z "$BASH_VERSION" ]; then
  echo "Error: This script requires bash, but you're running it with: $0" >&2
  echo "Please run: bash $0" >&2
  exit 1
fi

# Returns:
# 0 = valid expression
# 1 = invalid expression
# Sets EXP_TYPE to "test" for [[ ]], "math" for (( )), or "unknown"
is_valid_expression() {
  local expr="$1"
  EXP_TYPE=""
  
  # Strip leading/trailing whitespace
  expr="${expr#"${expr%%[![:space:]]*}"}"
  expr="${expr%"${expr##*[![:space:]]}"}"
  
  # Empty check
  [[ -z "$expr" ]] && return 1
  
  # If wrapped in (( )), strip them and mark as math
  if [[ "$expr" =~ ^\(\(.*\)\)$ ]]; then
    # Remove outer (( ))
    expr="${expr#\(\(}"
    expr="${expr%\)\)}"
    # Strip whitespace again
    expr="${expr#"${expr%%[![:space:]]*}"}"
    expr="${expr%"${expr##*[![:space:]]}"}"
    [[ -z "$expr" ]] && return 1
    EXP_TYPE="math"
    return 0
  fi
  
  # Reject nested [[ ]]
  [[ "$expr" =~ ^\[\[.*\]\]$ ]] && return 1
  
  # Reject expressions with [ ] brackets (old test syntax)
  if [[ "$expr" == *'['* && "$expr" == *']'* ]]; then
    return 1
  fi
  
  # Reject command substitutions
  if [[ "$expr" == *'$('* || "$expr" == *'`'* ]]; then
    return 1
  fi
  
  # Try math first (more specific patterns)
  if is_math_expression "$expr"; then
    EXP_TYPE="math"
    return 0
  fi
  
  # Then try test
  if is_test_expression "$expr"; then
    EXP_TYPE="test"
    return 0
  fi
  
  return 1
}

is_math_expression() {
  local expr="$1"
  
  # Check for math-specific patterns
  # 1. Increment/decrement
  local inc_dec_pattern='^[[:space:]]*((\+\+|--)[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*|[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(\+\+|--))[[:space:]]*$'
  if [[ "$expr" =~ $inc_dec_pattern ]]; then
    return 0
  fi
  
  # 2. Assignment operations
  local assign_pattern='^[[:space:]]*[a-zA-Z_][a-zA-Z0-9_]*[[:space:]]*(\+=|-=|\*=|/=|%=|&=|\|=|\^=|<<=|>>=|=)[[:space:]]*.*[[:space:]]*$'
  if [[ "$expr" =~ $assign_pattern ]]; then
    return 0
  fi
  
  # 3. Arithmetic operators
  if [[ "$expr" =~ [\+\-\*/%] ]]; then
    # Make sure it's not a file test like "-f"
    if [[ ! "$expr" =~ ^[[:space:]]*-[a-zA-Z][[:space:]] ]]; then
      return 0
    fi
  fi
  
  # 4. Bitwise operators
  local bitwise_pattern='[&|^~]'
  local shift_left='<<'
  local shift_right='>>'
  if [[ "$expr" =~ $bitwise_pattern ]] || [[ "$expr" == *"$shift_left"* ]] || [[ "$expr" == *"$shift_right"* ]]; then
    return 0
  fi
  
  # 5. Comparison operators with numeric operands
  local comp_pattern='^[[:space:]]*([^[:space:]]+)[[:space:]]*(==|!=|<=|>=|<|>)[[:space:]]*([^[:space:]]+)[[:space:]]*$'
  if [[ "$expr" =~ $comp_pattern ]]; then
    local left="${BASH_REMATCH[1]}"
    local right="${BASH_REMATCH[3]}"
    
    # Check if both sides are numeric or variables
    if [[ "$left" =~ ^-?[0-9]+$ || "$left" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]] && \
       [[ "$right" =~ ^-?[0-9]+$ || "$right" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
      
      # If both are literal numbers, it's math
      if [[ "$left" =~ ^-?[0-9]+$ && "$right" =~ ^-?[0-9]+$ ]]; then
        return 0
      fi
      
      # If both are variables, check if they contain numbers
      if [[ "$left" =~ ^[a-zA-Z_] && "$right" =~ ^[a-zA-Z_] ]]; then
        # Try to evaluate - if both expand to numbers, it's math
        local left_val="${!left:-}"
        local right_val="${!right:-}"
        if [[ "$left_val" =~ ^-?[0-9]+$ && "$right_val" =~ ^-?[0-9]+$ ]]; then
          return 0
        fi
      fi
    fi
  fi
  
  # 6. No-space arithmetic like "a+b" or "a<b" (only if variables/numbers)
  local no_space_pattern='^[[:space:]]*([a-zA-Z_][a-zA-Z0-9_]*|-?[0-9]+)([\+\-\*/%<>=]|==|!=|<=|>=)[[:space:]]*([a-zA-Z_][a-zA-Z0-9_]*|-?[0-9]+)[[:space:]]*$'
  if [[ "$expr" =~ $no_space_pattern ]]; then
    return 0
  fi
  
  # 6b. Bitwise no-space operators (using string matching to avoid regex issues)
  if [[ "$expr" == *'&'* || "$expr" == *'|'* || "$expr" == *'^'* ]]; then
    # Make sure it's not && or ||
    if [[ "$expr" != *'&&'* && "$expr" != *'||'* ]]; then
      return 0
    fi
  fi
  
  # 7. Complex expressions with parentheses (but not function calls)
  if [[ "$expr" == *'('* ]] && [[ ! "$expr" =~ ^[a-zA-Z_][a-zA-Z0-9_]*\( ]]; then
    # Contains parentheses but not a function call
    return 0
  fi
  
  # 8. Ternary operator
  if [[ "$expr" == *'?'*':'* ]]; then
    return 0
  fi
  
  # 9. Logical operators in math context
  if [[ "$expr" == *'&&'* || "$expr" == *'||'* ]]; then
    # If it contains arithmetic operators, it's math
    if [[ "$expr" =~ [\+\-\*/%] ]]; then
      return 0
    fi
  fi
  
  return 1
}

is_test_expression() {
  local expr="$1"
  
  # Unary file/string tests
  local unary_ops='-e|-f|-d|-r|-w|-x|-s|-L|-h|-b|-c|-p|-S|-O|-G|-u|-g|-k|-n|-z'
  local unary_pattern="^[[:space:]]*($unary_ops)[[:space:]]+[^[:space:]]"
  if [[ "$expr" =~ $unary_pattern ]]; then
    return 0
  fi
  
  # Binary file tests
  local binary_file_ops='-nt|-ot|-ef'
  local binary_file_pattern="[[:space:]]+($binary_file_ops)[[:space:]]+"
  if [[ "$expr" =~ $binary_file_pattern ]]; then
    return 0
  fi
  
  # Integer comparison tests
  local int_comp_ops='-eq|-ne|-lt|-le|-gt|-ge'
  local int_comp_pattern="[[:space:]]+($int_comp_ops)[[:space:]]+"
  if [[ "$expr" =~ $int_comp_pattern ]]; then
    return 0
  fi
  
  # String operators (with spacing required)
  local string_op_pattern='^[[:space:]]*[^[:space:]]+[[:space:]]+(=|=~)[[:space:]]+[^[:space:]]'
  if [[ "$expr" =~ $string_op_pattern ]]; then
    return 0
  fi
  
  # String/lexical comparison (must have spaces and not be all numbers)
  local str_comp_pattern='^[[:space:]]*([^[:space:]]+)[[:space:]]+(==|!=|<|>|<=|>=)[[:space:]]+([^[:space:]]+)[[:space:]]*$'
  if [[ "$expr" =~ $str_comp_pattern ]]; then
    local left="${BASH_REMATCH[1]}"
    local right="${BASH_REMATCH[3]}"
    
    # If either side is clearly a string (quoted, contains non-numeric chars, etc.)
    if [[ "$left" == \"* || "$left" == \'* || "$right" == \"* || "$right" == \'* ]]; then
      return 0
    fi
    if [[ ! "$left" =~ ^-?[0-9]+$ || ! "$right" =~ ^-?[0-9]+$ ]]; then
      return 0
    fi
  fi
  
  # Logical operators with test expressions
  if [[ "$expr" == *'&&'* || "$expr" == *'||'* ]]; then
    # Contains file tests or string comparisons
    if [[ "$expr" =~ -[a-z][[:space:]] ]] || [[ "$expr" =~ [[:space:]]+-[a-z] ]]; then
      return 0
    fi
  fi
  
  # Negation
  local negation_pattern='^[[:space:]]*![[:space:]]+'
  if [[ "$expr" =~ $negation_pattern ]]; then
    return 0
  fi
  
  return 1
}

# Returns: 0 = true, 1 = false, 2 = error/invalid
istrue() {
  local input="$*"
  
  # Handle empty input
  [[ -z "$input" ]] && return 1
  
  # Check for escaped/literal variable references (like \$VAR or "\\$VAR") and treat as false
  # These are likely mistakes where the variable wasn't meant to be expanded
  if [[ "$input" =~ ^\\?\$[a-zA-Z_] ]] || [[ "$input" =~ ^\".*\\+\$[a-zA-Z_] ]]; then
    return 1
  fi
  
  # Handle literal true/false values first (case insensitive)
  local lower="${input,,}"
  case "$lower" in
    true|yes|y|on|enabled|enable|1)
      return 0
      ;;
    false|no|n|off|disabled|disable|0)
      return 1
      ;;
  esac
  
  # Check if it's a valid expression
  if is_valid_expression "$input"; then
    case "$EXP_TYPE" in
      math)
        # Evaluate as arithmetic expression using eval to preserve variable modifications
        # Strip (( )) if present for evaluation
        local eval_expr="$input"
        if [[ "$eval_expr" =~ ^\(\(.*\)\)$ ]]; then
          eval_expr="${eval_expr#\(\(}"
          eval_expr="${eval_expr%\)\)}"
        fi
        
        # Use (( )) directly so that variable assignments persist
        if (( eval_expr )) 2>/dev/null; then
          return 0
        else
          return 1
        fi
        ;;
      test)
        # Evaluate as test expression
        if eval "[[ $input ]]" 2>/dev/null; then
          return 0
        else
          return 1
        fi
        ;;
      *)
        return 2  # Unknown type
        ;;
    esac
  fi
  
  # Try to evaluate as a simple numeric value
  if [[ "$input" =~ ^-?[0-9]+$ ]]; then
    if [[ "$input" -ne 0 ]]; then
      return 0
    else
      return 1
    fi
  fi
  
  # Try to evaluate as a command
  local first_word="${input%% *}"
  if command -v "$first_word" &>/dev/null; then
    # It's a command, try to execute it
    if eval "$input" &>/dev/null; then
      return 0
    else
      return 1
    fi
  fi
  
  # If we get here and it looks like invalid syntax, return false
  # Check for common invalid patterns
  if [[ "$input" =~ ^\(\(.*$ && ! "$input" =~ ^\(\(.*\)\)$ ]]; then
    # Starts with (( but doesn't end properly
    return 1
  fi
  
  # If it's a non-empty string that's not a keyword, treat as true
  [[ -n "$input" ]] && return 0 || return 1
}

# Convenience function - explicit version for compatibility
isfalse() {
  istrue "$@"
  local result=$?
  
  if [[ $result -eq 0 ]]; then
    return 1  # was true, return false
  elif [[ $result -eq 1 ]]; then
    return 0  # was false, return true
  else
    return "$result"  # propagate error codes
  fi
}

istrue "$@"