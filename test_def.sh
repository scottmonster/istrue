# Category 1: Basic Values
test_istrue "true" "true" "BASIC" "Command 'true' should return true"
test_istrue "false" "false" "BASIC" "Command 'false' should return false"
test_istrue "" "false" "BASIC" "Empty string should return false"
test_istrue " " "true" "BASIC" "Space string should return true"
test_istrue "lkjhsadfnj" "true" "BASIC" "Random string should return true"

# Category 2: Numeric Values
test_istrue "0" "false" "NUMERIC" "Numeric 0 should return false"
test_istrue "1" "true" "NUMERIC" "Numeric 1 should return true"
test_istrue "-1" "true" "NUMERIC" "Negative numbers should return true"
test_istrue "42" "true" "NUMERIC" "Positive numbers should return true"
test_istrue "+1" "true" "NUMERIC" "Positive sign with number should return true"
test_istrue "000" "false" "NUMERIC" "Leading zeros with zero should return false"
test_istrue "-0" "false" "NUMERIC" "Negative zero should return false"
test_istrue "01" "true" "NUMERIC" "Non-zero with leading zero should return true"
test_istrue "1.0" "true" "NUMERIC" "Float notation should be treated as string command"

# Category 3: Command Execution
test_istrue "echo hello" "true" "COMMAND" "Command that succeeds and outputs should return true"
test_istrue "ls /etc/passwd" "true" "COMMAND" "Command that lists existing file should return true"
test_istrue "ls /nonexistent/file" "false" "COMMAND" "Command that fails should return false"
test_istrue "grep -q root /etc/passwd" "true" "COMMAND" "Grep that finds a match should return true"
test_istrue "grep -q nonexistentuser /etc/passwd" "false" "COMMAND" "Grep that finds no match should return false"
test_istrue "command -v ls" "true" "COMMAND" "Command that checks if ls exists should return true"
test_istrue "command -v nonexistentcmd" "false" "COMMAND" "Command that checks if nonexistent command exists should return false"

# Category 4: Quoted Arguments
test_istrue '"echo this is quoted"' "true" "QUOTES" "Double-quoted command should return true"
test_istrue 'echo "this is partially quoted"' "true" "QUOTES" "Command with quoted args should return true"
test_istrue 'echo "multiple" "quoted" "args"' "true" "QUOTES" "Command with multiple quoted args should return true"
test_istrue 'echo -e "special\nchars"' "true" "QUOTES" "Command with special chars in quotes should return true"
test_istrue "'true'" "true" "QUOTES" "Single-quoted true command should work"
test_istrue '"true"' "true" "QUOTES" "Double-quoted true command should work"
test_istrue 'echo "nested'"'"'quotes"' "true" "QUOTES" "Mixed single and double quotes should work"
test_istrue "echo 'can'\"'\"'t'" "true" "QUOTES" "Escaped quotes in single quotes should work"

# Category 5: File Test Expressions
test_istrue "-f /etc/passwd" "true" "FILE_TEST" "Test for existing file should return true"
test_istrue "-f /nonexistent/file" "false" "FILE_TEST" "Test for non-existent file should return false"
test_istrue "-d /etc" "true" "FILE_TEST" "Test for existing directory should return true"
test_istrue "-d /nonexistent/dir" "false" "FILE_TEST" "Test for non-existent directory should return false"
test_istrue "-r /etc/passwd" "true" "FILE_TEST" "Test for readable file should return true"
test_istrue "-w /etc/passwd" "false" "FILE_TEST" "Test for writable file should return false for non-root"
test_istrue "-e /etc/passwd" "true" "FILE_TEST" "Test for file existence with -e should return true"
test_istrue "-e /nonexistent" "false" "FILE_TEST" "Test for non-existent with -e should return false"
test_istrue "-s /etc/passwd" "true" "FILE_TEST" "Test for non-empty file should return true"
test_istrue "-x /bin/ls" "true" "FILE_TEST" "Test for executable file should return true"
test_istrue "-x /etc/passwd" "false" "FILE_TEST" "Test for non-executable file should return false"
test_istrue "-L /etc/localtime || -f /etc/localtime" "true" "FILE_TEST" "Test for symlink or file should return true"

# Category 6: Expressions
test_istrue "1 -eq 1" "true" "EXPRESSION" "Expression that is true should return true"
test_istrue "1 -eq 2" "false" "EXPRESSION" "Expression that is false should return false"
test_istrue "5 -gt 3" "true" "EXPRESSION" "Greater than comparison that is true should return true"
test_istrue "3 -gt 5" "false" "EXPRESSION" "Greater than comparison that is false should return false"
test_istrue "'hello' = 'hello'" "true" "EXPRESSION" "String equality that is true should return true"
test_istrue "'hello' = 'world'" "false" "EXPRESSION" "String equality that is false should return false"
test_istrue "'abc' != 'def'" "true" "EXPRESSION" "String inequality should return true"

# Category 7: String Test Operators
test_istrue "-z ''" "true" "STRING_TEST" "Empty string test with -z should return true"
test_istrue "-z 'content'" "false" "STRING_TEST" "Non-empty string test with -z should return false"
test_istrue "-n 'content'" "true" "STRING_TEST" "Non-empty string test with -n should return true"
test_istrue "-n ''" "false" "STRING_TEST" "Empty string test with -n should return false"

# Category 8: Test Syntax Variations
test_istrue "[ 1 -eq 1 ]" "true" "TEST_SYNTAX" "Single bracket test should work"
test_istrue "[[ 1 -eq 1 ]]" "true" "TEST_SYNTAX" "Double bracket test should work"
test_istrue "test 1 -eq 1" "true" "TEST_SYNTAX" "Test command should work"
test_istrue "[[ 'hello' == 'hello' ]]" "true" "TEST_SYNTAX" "Double equals in double brackets should work"
test_istrue "[[ 'hello' == hell* ]]" "true" "TEST_SYNTAX" "Pattern matching in double brackets should work"
test_istrue "[[ 'hello' == bye* ]]" "false" "TEST_SYNTAX" "Non-matching pattern should return false"
test_istrue "[[ 'hello' =~ ^hel ]]" "true" "TEST_SYNTAX" "Regex matching should work"
test_istrue "[[ 'hello' =~ ^bye ]]" "false" "TEST_SYNTAX" "Non-matching regex should return false"
test_istrue "[[ 3 -gt 2 ]]" "true" "TEST_SYNTAX" "Numeric compare true in [[ ]]"
test_istrue "[[ 3 -gt 5 ]]" "false" "TEST_SYNTAX" "Numeric compare false in [[ ]]"
test_istrue "[ 3 -gt 2 ]" "true" "TEST_SYNTAX" "Test builtin true"
test_istrue "[ -n 'x' -a -z '' ]" "true" "TEST_SYNTAX" "-a with true && true"

# Category 9: Arithmetic Expressions
test_istrue "((3==4))" "false" "ARITHMETIC" "Arithmetic equality that is false should return false"
test_istrue "((5==5))" "true" "ARITHMETIC" "Arithmetic equality that is true should return true"
test_istrue "((10>5))" "true" "ARITHMETIC" "Arithmetic greater than should return true"
test_istrue "((3<2))" "false" "ARITHMETIC" "Arithmetic less than should return false"
test_istrue "((1+1==2))" "true" "ARITHMETIC" "Arithmetic addition equation should return true"
test_istrue "((10/2==5))" "true" "ARITHMETIC" "Arithmetic division equation should return true"
test_istrue "((2**3==8))" "true" "ARITHMETIC" "Arithmetic exponentiation should return true"
test_istrue "((5%3==2))" "true" "ARITHMETIC" "Arithmetic modulus should return true"
test_istrue "((1&&1))" "true" "ARITHMETIC" "Arithmetic logical AND with true values should return true"
test_istrue "((1||0))" "true" "ARITHMETIC" "Arithmetic logical OR should return true"
test_istrue "((0))" "false" "ARITHMETIC" "Arithmetic zero should return false"
test_istrue "((1))" "true" "ARITHMETIC" "Arithmetic non-zero should return true"
test_istrue "((-5))" "true" "ARITHMETIC" "Arithmetic negative number should return true"
test_istrue "((!0))" "true" "ARITHMETIC" "Logical NOT of 0 is true"
test_istrue "((!1))" "false" "ARITHMETIC" "Logical NOT of non-zero is false"

# Category 10: Complex Arithmetic
test_istrue "(((5+3)*2==16))" "true" "ARITHMETIC_COMPLEX" "Complex arithmetic with parentheses should work"
test_istrue "((10>5 && 3<7))" "true" "ARITHMETIC_COMPLEX" "Arithmetic with logical operators should work"
test_istrue "((1?42:0))" "true" "ARITHMETIC_COMPLEX" "Ternary operator should work"
test_istrue "((0?42:13))" "true" "ARITHMETIC_COMPLEX" "Ternary with false condition should return else value"
test_istrue "((2+3*4==14))" "true" "ARITHMETIC_COMPLEX" "Multiplication before addition should work"
test_istrue "((10-5-2==3))" "true" "ARITHMETIC_COMPLEX" "Left-to-right subtraction should work"
test_istrue "((2**3**2==512))" "true" "ARITHMETIC_COMPLEX" "Right-to-left exponentiation should work"
test_istrue "((1+2>2))" "true" "ARITHMETIC_COMPLEX" "Addition before comparison should work"
test_istrue "((5>3==1))" "true" "ARITHMETIC_COMPLEX" "Comparison before equality should work"
test_istrue "((1&&1&&1))" "true" "ARITHMETIC_COMPLEX" "Multiple AND operations should work"
test_istrue "((1&&1&&0))" "false" "ARITHMETIC_COMPLEX" "Multiple AND with one false should return false"
test_istrue "((0||0||1))" "true" "ARITHMETIC_COMPLEX" "Multiple OR with one true should return true"
test_istrue "((0||0||0))" "false" "ARITHMETIC_COMPLEX" "Multiple OR all false should return false"
test_istrue "((1&&(0||1)))" "true" "ARITHMETIC_COMPLEX" "AND with OR in parentheses should work"
test_istrue "((!0&&!0))" "true" "ARITHMETIC_COMPLEX" "Multiple negations should work"

# Category 11: Ternary Operator
test_istrue "((1?1:0))" "true" "TERNARY" "Ternary with true result should return true"
test_istrue "((0?1:0))" "false" "TERNARY" "Ternary with false result should return false"
test_istrue "((5>3?10:20))" "true" "TERNARY" "Ternary with comparison condition should work"
test_istrue "((5<3?10:20))" "true" "TERNARY" "Ternary false condition should evaluate else branch"
test_istrue "((1?1?1:0:0))" "true" "TERNARY" "Nested ternary should work"

# Category 12: Complex Expressions
test_istrue "[ -f /etc/passwd ] && [ -d /etc ]" "true" "COMPLEX" "AND expression with both parts true should return true"
test_istrue "[ -f /nonexistent ] && [ -d /etc ]" "false" "COMPLEX" "AND expression with first part false should return false"
test_istrue "[ -f /nonexistent ] || [ -d /etc ]" "true" "COMPLEX" "OR expression with second part true should return true"
test_istrue "[ -f /nonexistent ] || [ -d /nonexistent ]" "false" "COMPLEX" "OR expression with both parts false should return false"
test_istrue "[[ -f /etc/passwd && -d /etc ]]" "true" "COMPLEX" "Multiple conditions in double brackets should work"
test_istrue "[[ -f /etc/passwd ]] && [[ -d /etc ]]" "true" "COMPLEX" "Multiple separate test conditions should work"
test_istrue "(( (5>3) && (10>8) ))" "true" "COMPLEX" "Nested comparisons in arithmetic should work"

# Category 13: Variable Tests
echo "Setting test variables..."
EMPTY_VAR=""
TRUE_VAR="true"
FALSE_VAR="false"
test_istrue '\$TRUE_VAR' "false" "VARIABLES" "Variable reference (not value) should be false without eval"
test_istrue '"\\\$TRUE_VAR"' "false" "VARIABLES" "Quoted variable reference should be false without eval"
test_istrue "$TRUE_VAR" "true" "VARIABLES" "Expanded true variable should return true"
test_istrue "$FALSE_VAR" "false" "VARIABLES" "Expanded false variable should return false"
test_istrue "$EMPTY_VAR" "false" "VARIABLES" "Expanded empty variable should return false"
test_istrue '${UNSET_VAR}' "false" "VARIABLES" "Brace expansion of unset var should return false"
test_istrue "$UNSET_VAR" "false" "VARIABLES" "Unset expands to empty should return false"
test_istrue "$(echo "${UNSET_VAR:-true}")" "true" "VARIABLES" "Parameter expansion inside substitution should work"

# Category 14: Edge Cases and Security
test_istrue "$(echo true)" "true" "EDGE" "Command substitution with true should return true"
test_istrue "$(echo false)" "false" "EDGE" "Command substitution with false should return false"
test_istrue "$(ls /nonexistent 2>/dev/null); echo safe" "true" "EDGE" "Command that fails but semicolon separates should still run second part"
test_istrue '$(ls) > /dev/null' "true" "EDGE" "Command with output redirection should work as expected"
test_istrue '`true`' "true" "EDGE" "Backtick command substitution with true should return true"
test_istrue '`false`' "false" "EDGE" "Backtick command substitution with false should return false"
test_istrue "`echo true`" "true" "EDGE" "Legacy backticks substitution"
test_istrue "$(printf '  true  ')" "true" "EDGE" "Substitution with spaces around true"

# Category 15: Invalid Expression Handling
test_istrue "((1+2)" "false" "INVALID" "Malformed arithmetic expression should return false"
test_istrue "((1+2)))" "false" "INVALID" "Extra parenthesis should return false"
test_istrue "((" "false" "INVALID" "Empty arithmetic expression should return false"
test_istrue "((3 4))" "false" "INVALID" "Missing operator should return false"
test_istrue "((+))" "false" "INVALID" "Operator without operands should return false"
test_istrue "((3===4))" "false" "INVALID" "Invalid operator should return false"
test_istrue "((1 2 3))" "false" "INVALID" "Numbers without operators should fail"
test_istrue "((++))" "false" "INVALID" "Increment without variable should fail"
test_istrue "((--))" "false" "INVALID" "Decrement without variable should fail"
test_istrue "((1/))" "false" "INVALID" "Division without second operand should fail"
test_istrue "((*/2))" "false" "INVALID" "Multiplication without first operand should fail"
test_istrue "[[]]" "false" "INVALID" "Empty double bracket test should fail"
test_istrue "[]" "false" "INVALID" "Empty single bracket test should fail"
test_istrue "((1+" "false" "INVALID" "Unclosed arithmetic should fail"
test_istrue "[[ 1 -eq" "false" "INVALID" "Incomplete comparison should fail"
test_istrue "[[" "false" "INVALID" "Dangling [[ should be false"
test_istrue "]" "false" "INVALID" "Stray ] is syntax error should return false"
test_istrue "fi" "false" "INVALID" "Dangling fi should return false"
test_istrue "}" "false" "INVALID" "Stray brace should return false"

# Category 16: Bitwise Operations
test_istrue "((8>>2==2))" "true" "BITWISE" "Right shift should work"
test_istrue "((2<<1==4))" "true" "BITWISE" "Left shift should work"
test_istrue "(((5&3)==1))" "true" "BITWISE" "Bitwise AND should work"
test_istrue "((5|3==7))" "true" "BITWISE" "Bitwise OR should work"
test_istrue "((5^3==6))" "true" "BITWISE" "Bitwise XOR should work"
test_istrue "((~0==-1))" "true" "BITWISE" "Bitwise NOT of 0 should be -1"
test_istrue "((~-1==0))" "true" "BITWISE" "Bitwise NOT of -1 should be 0"
test_istrue "(((~5&5)==0))" "true" "BITWISE" "Number AND its complement should be 0"
test_istrue "(( (3&~1)==2 ))" "true" "BITWISE" "Masking with bitwise NOT"

# Category 17: Boolean Case Variants & Whitespace
test_istrue "TRUE" "true" "BOOLEAN_CASE" "Uppercase TRUE should be true"
test_istrue "False" "false" "BOOLEAN_CASE" "Mixed-case False should be false"
test_istrue "   true" "true" "WHITESPACE" "Leading spaces before true should be true"
test_istrue "false   " "false" "WHITESPACE" "Trailing spaces after false should be false"
test_istrue "  TrUe  " "true" "WHITESPACE" "Spaces around mixed-case true should be true"
test_istrue "	" "true" "WHITESPACE" "Tab character should return true"
test_istrue "   " "true" "WHITESPACE" "Multiple spaces should return true"
test_istrue $'\n' "true" "WHITESPACE" "Newline character should return true"
test_istrue $'\t' "true" "WHITESPACE" "Tab via ANSI-C quoting should return true"
test_istrue "  1  " "true" "WHITESPACE" "Number with surrounding spaces should return true"
test_istrue $'hello\nworld' "true" "WHITESPACE" "String with embedded newline should return true"
test_istrue $'\r\n' "true" "WHITESPACE" "CRLF should return true"
test_istrue $' \t \n ' "true" "WHITESPACE" "Mixed ASCII whitespace only should return true"
test_istrue $' \ttrue\t ' "true" "WHITESPACE" "Whitespace with bare true in middle should be true"

# Category 18: Negation Tests
test_istrue "! false" "true" "NEGATION" "Negation of false should return true"
test_istrue "! true" "false" "NEGATION" "Negation of true should return false"
test_istrue "! -f /nonexistent" "true" "NEGATION" "Negation of false file test should return true"
test_istrue "! -d /etc" "false" "NEGATION" "Negation of true directory test should return false"
test_istrue "! ((0))" "true" "NEGATION" "Negation of arithmetic zero should return true"
test_istrue "! ((1))" "false" "NEGATION" "Negation of arithmetic non-zero should return false"

# Category 19: Command Chaining and Pipes
test_istrue "true && true" "true" "CHAINING" "AND chain with both true should return true"
test_istrue "true && false" "false" "CHAINING" "AND chain with second false should return false"
test_istrue "false || true" "true" "CHAINING" "OR chain with second true should return true"
test_istrue "false || false" "false" "CHAINING" "OR chain with both false should return false"
test_istrue "true && false || true" "true" "CHAINING" "AND/OR precedence should yield true"
test_istrue "( false && true ) || ( true && true )" "true" "CHAINING" "Grouped logic should be true"
test_istrue "echo test | grep -q test" "true" "PIPES" "Pipe to grep with match should return true"
test_istrue "echo test | grep -q nomatch" "false" "PIPES" "Pipe to grep without match should return false"
test_istrue "true | true" "true" "PIPES" "Pipe between true commands should return true"
test_istrue "false | true" "true" "PIPES" "Pipe returns exit status of last command"
test_istrue "true | false" "false" "PIPES" "Pipeline exit is last cmd (false)"
test_istrue "echo ok | grep -q ok" "true" "PIPES" "grep finds 'ok' should return true"
test_istrue "echo ok | grep -q no" "false" "PIPES" "grep does not find 'no' should return false"

# Category 20: Subshells and Command Substitution
test_istrue "(true)" "true" "SUBSHELL" "Subshell with true should return true"
test_istrue "(false)" "false" "SUBSHELL" "Subshell with false should return false"
test_istrue "(exit 0)" "true" "SUBSHELL" "Subshell with exit 0 should return true"
test_istrue "(exit 1)" "false" "SUBSHELL" "Subshell with exit 1 should return false"
test_istrue "(exit 42)" "false" "SUBSHELL" "Subshell with non-zero exit should return false"
test_istrue "(exit 127)" "false" "SUBSHELL" "Exit 127 (command not found) should return false"
test_istrue "(exit 255)" "false" "SUBSHELL" "Exit 255 should return false"

# Category 21: Grouping & Blocks
test_istrue "{ true; }" "true" "BLOCK" "Brace group true"
test_istrue "{ false; }" "false" "BLOCK" "Brace group false"
test_istrue "{ echo x >/dev/null; true; }" "true" "BLOCK" "Multi-command block final status true"
test_istrue "{ true; false; }" "false" "BLOCK" "Last command determines status should return false"
test_istrue "false; true" "true" "BLOCK" "Semicolon sequence should return status of last (true)"
test_istrue "true; false" "false" "BLOCK" "Last command false should return overall false"
test_istrue "{ false; :; }" "true" "BLOCK" "':' builtin succeeds, last wins should return true"

# Category 22: Special Characters and Escaping
test_istrue "echo \!" "true" "SPECIAL_CHARS" "Escaped exclamation should work"
test_istrue 'echo \$HOME' "true" "SPECIAL_CHARS" "Escaped dollar sign should work"
test_istrue "echo \\*" "true" "SPECIAL_CHARS" "Escaped asterisk should work"
test_istrue "echo \;" "true" "SPECIAL_CHARS" "Escaped semicolon should work"
test_istrue 'echo "a|b"' "true" "SPECIAL_CHARS" "Quoted pipe character should work"
test_istrue 'echo "a&b"' "true" "SPECIAL_CHARS" "Quoted ampersand should work"
test_istrue "echo \"a*b\"" "true" "SPECIAL_CHARS" "Quoted glob should not expand; echo exits 0"

# Category 23: Comparison Edge Cases
test_istrue "((0==0))" "true" "COMPARISON" "Zero equality should return true"
test_istrue "((-1==-1))" "true" "COMPARISON" "Negative equality should return true"
test_istrue "((1!=2))" "true" "COMPARISON" "Inequality should return true"
test_istrue "((1!=1))" "false" "COMPARISON" "False inequality should return false"
test_istrue "((5>=5))" "true" "COMPARISON" "Greater than or equal with equal should return true"
test_istrue "((5>=6))" "false" "COMPARISON" "Greater than or equal with less should return false"
test_istrue "((3<=3))" "true" "COMPARISON" "Less than or equal with equal should return true"
test_istrue "((3<=2))" "false" "COMPARISON" "Less than or equal with greater should return false"

# Category 24: Empty and No-op Commands
test_istrue ":" "true" "EMPTY_CMD" "Colon (no-op) command should return true"
test_istrue "true;" "true" "EMPTY_CMD" "Command with trailing semicolon should work"
test_istrue "true ;true" "true" "EMPTY_CMD" "Two commands separated by semicolon should work"
test_istrue "exit 0 || true" "true" "EMPTY_CMD" "Exit in subshell with OR fallback should work"

# Category 25: Output Redirection
test_istrue "echo test >/dev/null" "true" "REDIRECT" "Stdout redirect should succeed"
test_istrue "echo test 2>/dev/null" "true" "REDIRECT" "Stderr redirect should succeed"
test_istrue "echo test &>/dev/null" "true" "REDIRECT" "Both stdout and stderr redirect should succeed"
test_istrue "ls /nonexistent 2>/dev/null" "false" "REDIRECT" "Failed command with stderr redirect should return false"
test_istrue "cat /etc/passwd >/dev/null" "true" "REDIRECT" "Read file to null should succeed"
test_istrue "true >/dev/null 2>&1" "true" "REDIRECT" "True with redirection should be true"
test_istrue "false 2>/dev/null" "false" "REDIRECT" "False remains false even with redirection"
test_istrue "cat </dev/null" "true" "REDIRECT" "Input redirection should succeed"
test_istrue "cat <<< hi >/dev/null" "true" "REDIRECT" "Here-string should succeed"
test_istrue "grep -q hi <<<'hi'" "true" "REDIRECT" "Here-string with grep should be true"

# Category 26: Nested Operations
test_istrue "((((1))))" "true" "NESTED" "Quadruple nested parentheses should work"
test_istrue "((((5+3)*2-1)==15))" "true" "NESTED" "Nested arithmetic with operations should work"

# Category 27: Comma Operator
test_istrue "((1,2,3))" "true" "COMMA" "Comma operator should return last value"
test_istrue "((5,0))" "false" "COMMA" "Comma operator with last value 0 should return false"
test_istrue "((0,1))" "true" "COMMA" "Comma operator should ignore first value"
test_istrue "((x=1,y=2,x+y))" "true" "COMMA" "Comma with assignments should work"
test_istrue "((x=5,x==5))" "true" "COMMA" "Assignment in arithmetic should work"
test_istrue "((y=0,!y))" "true" "COMMA" "Assignment of zero then negation should work"
test_istrue "((a=1,b=2,a+b==3))" "true" "COMMA" "Multiple assignments should work"

# Category 28: Number Edge Cases
test_istrue "((00==0))" "true" "NUMBER_EDGE" "Leading zeros should be ignored"
test_istrue "((007==7))" "true" "NUMBER_EDGE" "Multiple leading zeros should be ignored"
test_istrue "((0x10==16))" "true" "NUMBER_EDGE" "Hexadecimal notation should work"
test_istrue "((0x0==0))" "true" "NUMBER_EDGE" "Hex zero should equal decimal zero"
test_istrue "((0xFF==255))" "true" "NUMBER_EDGE" "Uppercase hex should work"
test_istrue "((9999999999>1))" "true" "NUMBER_EDGE" "Very large number comparison should work"
test_istrue "((999999999999999999>0))" "true" "NUMBER_EDGE" "Extremely large number should work"
test_istrue "((1000000*1000000==1000000000000))" "true" "NUMBER_EDGE" "Large multiplication should work"

# Category 29: Division and Modulo
test_istrue "((10/3==3))" "true" "DIVISION" "Integer division should truncate"
test_istrue "((10/3==3.33))" "false" "DIVISION" "Floating point comparison should fail (bash uses integers)"
test_istrue "((7%4==3))" "true" "DIVISION" "Modulo operation should work"
test_istrue "((100%10==0))" "true" "DIVISION" "Even modulo should return 0"
test_istrue "((-10%3==-1))" "true" "DIVISION" "Negative modulo should work"
test_istrue "((100-100==0))" "true" "DIVISION" "Subtraction to zero should work"
test_istrue "((1-1==0))" "true" "DIVISION" "Simple subtraction to zero should work"
test_istrue "((0*1000000==0))" "true" "DIVISION" "Multiply by zero should give zero"
test_istrue "((0+0==0))" "true" "DIVISION" "Zero addition should work"
test_istrue "(( 10/0 ))" "false" "DIVISION" "Division by zero should be false"

# Category 30: Unary Operators
test_istrue "((-5<0))" "true" "UNARY" "Negative number less than zero should return true"
test_istrue "((+5>0))" "true" "UNARY" "Positive number greater than zero should return true"
test_istrue "((-(-5)==5))" "true" "UNARY" "Double negation should work"
test_istrue "((-(5)==-5))" "true" "UNARY" "Negation of positive should work"

# Category 31: String Comparisons
test_istrue "[[ '' = '' ]]" "true" "STRING_EDGE" "Empty string equality should return true"
test_istrue "[[ 'a' < 'b' ]]" "true" "STRING_EDGE" "Lexicographic less than should work"
test_istrue "[[ 'b' > 'a' ]]" "true" "STRING_EDGE" "Lexicographic greater than should work"
test_istrue "[[ '10' < '9' ]]" "true" "STRING_EDGE" "String comparison (not numeric) should work"
test_istrue "[[ 'ABC' == 'abc' ]]" "false" "STRING_EDGE" "Case-sensitive comparison should work"
test_istrue "[[ 'ABC' != 'abc' ]]" "true" "STRING_EDGE" "Case-sensitive comparison should work"

# Category 32: Process Exit Status
test_istrue "bash -c 'exit 0'" "true" "PROCESS_EXIT" "Bash subprocess with exit 0 should return true"
test_istrue "bash -c 'exit 1'" "false" "PROCESS_EXIT" "Bash subprocess with exit 1 should return false"
test_istrue "sh -c true" "true" "PROCESS_EXIT" "Shell subprocess with true should return true"
test_istrue "sh -c false" "false" "PROCESS_EXIT" "Shell subprocess with false should return false"

# Category 33: Stress Tests
test_istrue "((1+1+1+1+1+1+1+1+1+1==10))" "true" "STRESS" "Long addition chain should work"
test_istrue "((1*1*1*1*1*1*1*1*1*1==1))" "true" "STRESS" "Long multiplication chain should work"
test_istrue "((1&&1&&1&&1&&1&&1&&1&&1&&1))" "true" "STRESS" "Long logical AND chain should work"
test_istrue "((0||0||0||0||0||0||0||0||1))" "true" "STRESS" "Long logical OR chain should work"
test_istrue "(( (1<<30) > (1<<29) ))" "true" "STRESS" "Shifts with big numbers"

# Category 34: Built-in Commands
test_istrue "type ls >/dev/null 2>&1" "true" "BUILTINS" "Type command should succeed for existing command"
test_istrue "type nonexistentcmd123 >/dev/null 2>&1" "false" "BUILTINS" "Type command should fail for non-existent command"
test_istrue "command -v bash >/dev/null" "true" "BUILTINS" "Command -v should succeed for bash"
test_istrue "which ls >/dev/null 2>&1" "true" "BUILTINS" "Which command should find ls"

# Category 35: Glob and Brace Expansion
test_istrue "[[ /etc/passwd == /etc/passwd ]]" "true" "GLOB" "Exact path match should work"
test_istrue "[[ /etc/passwd == /etc/* ]]" "true" "GLOB" "Wildcard pattern should match"
test_istrue "[[ /etc/passwd == /tmp/* ]]" "false" "GLOB" "Non-matching wildcard should fail"
test_istrue "[[ abc == a?c ]]" "true" "GLOB" "Question mark wildcard should match"
test_istrue "[[ abc == a??c ]]" "false" "GLOB" "Wrong number of wildcards should not match"
test_istrue "echo * >/dev/null" "true" "GLOB" "Glob expansion typically succeeds"
test_istrue "echo {a,b} >/dev/null" "true" "GLOB" "Brace expansion produces words; echo succeeds"
test_istrue "[[ a == a* ]]" "true" "GLOB" "Pattern match true"
test_istrue "[[ a == b* ]]" "false" "GLOB" "Pattern match false"

# Category 36: Short-Circuit Behavior
test_istrue "false && nonexistentcommand123" "false" "SHORT_CIRCUIT" "AND should short-circuit on false"
test_istrue "true || nonexistentcommand123" "true" "SHORT_CIRCUIT" "OR should short-circuit on true"
test_istrue "((0 && 1/0))" "false" "SHORT_CIRCUIT" "Arithmetic AND should short-circuit (avoid division by zero)"
test_istrue "((1 || 1/0))" "true" "SHORT_CIRCUIT" "Arithmetic OR should short-circuit (avoid division by zero)"

# Category 37: Filesystem Temp Tests
test_istrue 'f=$(mktemp) && [[ -f "$f" ]]' "true" "FS_TMP" "mktemp created file exists"
test_istrue 'f=$(mktemp) && rm -f "$f" && [[ -e "$f" ]]' "false" "FS_TMP" "Removed temp file should not exist"
test_istrue 'd=$(mktemp -d) && [[ -d "$d" ]]' "true" "FS_TMP" "mktemp -d creates directory"
test_istrue 'd=$(mktemp -d) && rmdir "$d" && [[ -d "$d" ]]' "false" "FS_TMP" "Removed temp dir should not exist"

# Category 38: Environment Isolation
test_istrue 'export X=1; [[ -n "$X" ]]' "true" "ENV_ISO" "Environment inside eval is visible to itself"
test_istrue '[[ -z "$SOME_DEF_NOT_SET" ]]' "true" "ENV_ISO" "Unset var empty inside subshell"

# Category 39: Arithmetic Limits
test_istrue "(( 2147483647 > 0 ))" "true" "ARITH_LIMITS" "Large positive int"
test_istrue "(( -2147483648 < 0 ))" "true" "ARITH_LIMITS" "Large negative int"

# BECAUSE WE CALL THE SCRIPT AND DON'T SOURCE IT THIS DOESN'T WORK THE SUBSHELL HAS NO CONTEXT OF OUR VARIABLES. WE ARE NOT CONCERNED WITH THIS RIGHT NOW
# Category 11: Assignment Operations (if supported by istrue)
assignment_var=5
# test_istrue "((assignment_var*=2))" "true" "ASSIGNMENT" "Multiplication assignment should work"
# test_istrue "((assignment_var==10))" "true" "ASSIGNMENT" "Variable should be modified by assignment"

# BECAUSE WE CALL THE SCRIPT AND DON'T SOURCE IT THIS DOESN'T WORK THE SUBSHELL HAS NO CONTEXT OF OUR VARIABLES. WE ARE NOT CONCERNED WITH THIS RIGHT NOW
# Category 6b: Arithmetic with Variables
# echo "Setting arithmetic test variables..."
# num_var=10
# another_num=5
# test_istrue "((num_var>another_num))" "true" "ARITHMETIC_VAR" "Variable comparison should work"
# test_istrue "((num_var==10))" "true" "ARITHMETIC_VAR" "Variable equality should work"
# test_istrue "((++num_var==11))" "true" "ARITHMETIC_VAR" "Pre-increment should work"
# test_istrue "((another_num+=5, another_num==10))" "true" "ARITHMETIC_VAR" "Assignment and comma operator should work"



# Category 40: Boolean Word Synonyms
test_istrue "yes" "true" "BOOLEAN_WORDS" "Common true synonym 'yes' should be true (if supported)"
test_istrue "no" "false" "BOOLEAN_WORDS" "Common false synonym 'no' should be false (if supported)"
test_istrue "on" "true" "BOOLEAN_WORDS" "'on' should be true (if supported)"
test_istrue "off" "false" "BOOLEAN_WORDS" "'off' should be false (if supported)"
test_istrue "y" "true" "BOOLEAN_WORDS" "Single-letter 'y' should be true (if supported)"
test_istrue "n" "false" "BOOLEAN_WORDS" "Single-letter 'n' should be false (if supported)"
test_istrue "enable" "true" "BOOLEAN_WORDS" "'enable' should be true (if supported)"
test_istrue "disable" "false" "BOOLEAN_WORDS" "'disable' should be false (if supported)"

# Category 41: File Timestamp & Link Edge Cases
test_istrue 'f1=$(mktemp) && sleep 1 && f2=$(mktemp) && [[ "$f2" -nt "$f1" ]]' "true" "FILE_TIME" "-nt newer-than should be true"
test_istrue 'f1=$(mktemp) && sleep 1 && f2=$(mktemp) && [[ "$f1" -ot "$f2" ]]' "true" "FILE_TIME" "-ot older-than should be true"
test_istrue 't=$(mktemp) && ln -s "$t" s && [[ -L s && -e s ]]' "true" "FILE_LINK" "Symlink to existing target: -L and -e true"
test_istrue 'ln -s /nonexistent s && [[ -L s && ! -e s ]]' "true" "FILE_LINK" "Broken symlink: -L true, -e false"
test_istrue 'p=$(mktemp -u) && mkfifo "$p" && [[ -p "$p" ]]' "true" "FILE_SPECIAL" "Named pipe should satisfy -p"

# Category 42: File Descriptors / TTY
test_istrue "true <&-" "true" "FD_TTY" "Command succeeds with stdin closed"
test_istrue "cat <&- >/dev/null" "false" "FD_TTY" "cat fails when stdin closed"

# Category 43: Background Jobs & wait
test_istrue "false & wait %1" "false" "BG_WAIT" "Background false reported by wait should be false"
test_istrue "true & wait %1" "true" "BG_WAIT" "Background true reported by wait should be true"
test_istrue "false & :; wait %1 || :; true" "true" "BG_WAIT" "Recover after bg failure and succeed overall"

# Category 44: Process Substitution & Pipemenu
test_istrue "diff <(echo a) <(echo a) >/dev/null" "true" "PROC_SUB" "Process substitution identical diff should be true"
test_istrue "comm <(printf 'a\nb\n') <(printf 'a\nc\n') >/dev/null" "true" "PROC_SUB" "comm executes successfully"

# Category 45: Bash Options Affecting [[ ]]
test_istrue "bash -c 'shopt -s extglob; [[ aaaa == a+(a) ]]'" "true" "BASH_SHOPT" "Extended globbing should match with extglob"
test_istrue "bash -c 'shopt -s nocasematch; [[ Foo == foo ]]'" "true" "BASH_SHOPT" "nocasematch makes [[ ]] case-insensitive"
test_istrue "bash -c 'shopt -u nocasematch; [[ Foo == foo ]]'" "false" "BASH_SHOPT" "Without nocasematch, case differs"

# Category 46: Execution Failures (126/Permission)
test_istrue 'f=$(mktemp); echo "echo hi" >"$f"; chmod -x "$f"; "$f" >/dev/null 2>&1' "false" "EXEC_FAIL" "Non-executable script: exit 126 should be false"
test_istrue 'd=$(mktemp -d); "$d" >/dev/null 2>&1' "false" "EXEC_FAIL" "Attempting to exec a directory should be false"

# Category 47: Unicode & Non-ASCII Whitespace
test_istrue $'\u00A0' "true" "UNICODE_WS" "NBSP should count as whitespace-only input (if treated as non-empty true)"
test_istrue $'\u2003' "true" "UNICODE_WS" "Em space treated as whitespace-only (if non-empty is true)"
test_istrue $' \u00A0 \t ' "true" "UNICODE_WS" "Mixed ASCII + Unicode whitespace"

# Category 48: Env / IFS Quirks
test_istrue 'IFS=, bash -c '\''test x,y = x,y'\'' ' "true" "ENV_IFS" "Setting IFS should not break simple equality"
test_istrue 'IFS= bash -c '\''[[ -n $IFS ]]'\'' ' "true" "ENV_IFS" "Empty IFS still defined, -n true"

# Category 49: More [[ Operators
test_istrue "[[ abc =~ ^a.c$ ]]" "true" "DOUBLE_BRACKET" "Regex dot should match single char"
test_istrue "[[ abc =~ ^ab$ ]]" "false" "DOUBLE_BRACKET" "Regex strict anchor should fail"
test_istrue "[[ -v BASH_VERSION ]]" "true" "DOUBLE_BRACKET" "-v var set test (bash>=4.2)"
test_istrue "bash -c 'unset ZZ; [[ ! -v ZZ ]]'" "true" "DOUBLE_BRACKET" "-v unset var should be false; negation true"

# Category 50: Pathological Length / Big Arg
test_istrue "printf '%*s' 5000 x >/dev/null" "true" "LONG_ARG" "Long arg handling via printf should succeed"