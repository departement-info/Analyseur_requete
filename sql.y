%{
#include <stdio.h>
#include <stdbool.h>
int yylex(void);
void yyerror(const char* s);
bool valid_flag = true;
bool where_clause_present = false;
bool missing_parameters = false;
%}

%token SELECT FROM WHERE AND OR INSERT INTO VALUES JOIN ON GROUP BY

%%

sql_stmt : select_stmt
         | insert_stmt
         ;

select_stmt : SELECT select_list FROM table_list where_clause group_by_clause join_clause
            ;

insert_stmt : INSERT INTO table_name '(' column_list ')' VALUES '(' value_list ')'
            ;

where_clause : WHERE expr
             | /* empty */
             ;

group_by_clause : GROUP BY column_name
                | /* empty */
                ;

join_clause : JOIN table_name ON expr
            | /* empty */
            ;

select_list : column_name
            | '*'  /* for selecting all columns */
            ;

column_list : column_name
            ;

value_list : value
           ;

value : /* some value */

%%

void yyerror(const char* s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
    valid_flag = false;
}

int main(void) {
    int result;

    // Process each SQL query separately
    do {
        valid_flag = true;  // Reset valid flag for each query
        where_clause_present = false;  // Reset where_clause_present flag for each query
        missing_parameters = false;  // Reset missing_parameters flag for each query

        result = yyparse();
        
        if (valid_flag) {
            if (where_clause_present) {
                if (missing_parameters) {
                    printf("SQL query is invalid: Missing parameters.\n");
                } else {
                    printf("SQL query is valid.\n");
                }
            } else {
                printf("SQL query is invalid: Missing WHERE clause.\n");
            }
        } else {
            printf("SQL query is invalid.\n");
        }
    } while (yylex() == 0);  // Continue parsing as long as there are more queries

    return 0;
}