*** Settings ***
Library    OperatingSystem
Library    String
Library    SeleniumLibrary
Library    main_python_methods.py
Library    DatabaseLibrary
Library    DateTime

*** Variables ***
${cookies_rejection}    W0wltc

*** Keywords ***
Evaluate the type of a given variable
    [Documentation]    Give in arguments the expected variable and its type
    [Tags]    variable_type    type
    [Arguments]    ${given_variable}
    ${variable_type}    Evaluate    type(${given_variable})
    Log To Console    Variable type: ${variable_type}

Research on Google
    [Documentation]    Take an argument from a direct question or the ChatGPT conversation
    [Tags]    google    google_research
    [Arguments]    ${research_text}
    Open Browser    https://google.fr/    Chrome
    Maximize Browser Window
    Get Window Titles    CURRENT
    Click Button    ${cookies_rejection}
    Input Text    //*[@id="APjFqb"]    ${research_text}
    # \\13 représente le code ASCII pour la touche "Entrée"
    Press Keys    //*[@id="APjFqb"]    RETURN

Create directory if does not exist
    [Arguments]    ${folder_path}
    ${dir_exists}=    Directory Exists    ${folder_path}
    IF    '${dir_exists}' == 'False'
        Create Directory    ${folder_path}
        Log    The folder located in the path "${folder_path}" has been created.
    ELSE
        Log    The folder from the following path "${folder_path}" already exists.
    END

Create database if does not exist
    [Arguments]    ${file_path}
    ${file_exists}=    File Exists    ${file_path}
    IF    '${file_exists}' == 'False'
        Connect To Database Using Custom Params    sqlite3    database="${file_path}", isolation_level=None
        Execute SQL String    CREATE TABLE texts (id INTEGER PRIMARY KEY AUTOINCREMENT,test_name varchar,datetime varchar,content varchar);
        Execute SQL String    CREATE TABLE images (id INTEGER PRIMARY KEY AUTOINCREMENT,test_name varchar,datetime varchar,content varchar);
        Log    The database located in the path "${file_path}" has been created.
    ELSE
        Log    The database at the following path "${file_path}" already exists.
    END

Launch a test with a command line
    [Documentation]    Execution of a command line with the "Run" keyword in the OperatingSystem library
    [Arguments]    ${command_line}
    ${result}    Run    ${command_line}
