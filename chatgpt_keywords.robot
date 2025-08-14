*** Settings ***
Library    RPA.OpenAI
Library    String
Library    OperatingSystem
Library    Collections
Resource    main_keywords.robot
Resource    my_variables.robot

*** Variables ***
${db_path}=     ./database/db_rf_chatgpt.db

*** Keywords ***
Connect to SQLiteDB
    [Documentation]    DEPRECATED: Connect To Database Using Custom Params    sqlite3    database="${db_path}", isolation_level=None
    ...    So we have to use for instance this Database library keyword: "Connect To Database"
    [Tags]    db    smoke
    Connect To Database    sqlite3    ${db_path}    


Asking ChatGPT
    [Documentation]    Call OpenAI Chat Completion API to generate a conversation.
    [Arguments]    ${chatgpt_conversation}    ${launching_question}
    Authorize To OpenAI    api_key=${my_api_key}
    # Get response without conversation history.
    ${response}   @{chatgpt_conversation}=     Chat Completion Create
    ...    temperature=0.6
    ...    user_content=${launching_question}
    Evaluate the type of a given variable    ${chatgpt_conversation}
    Log    ${response}
    RETURN    ${chatgpt_conversation}

Open file with conversation
    [Documentation]    Open a text file containing the conversation to pass as an argument to the ChatGPT keyword
    [Arguments]    ${path_text_file_conversation}
    ${text_file_conversation}    Get File    ${path_text_file_conversation}
    Log    ${text_file_conversation}
    RETURN    ${text_file_conversation}
    
Copy of the conversation in a text file
    [Documentation]    The content of the first and second answers from ChatGPT is inserted in a text file in a new directory
    [Tags]    file    copy
    [Arguments]    ${conversation}    ${file_extension}
    ${path_new_directory}    Set Variable    chatgpt_answers
    ${path_answers_file}    Set Variable    chatgpt_answers/answers.${file_extension}
    OperatingSystem.Create Directory    ${path_new_directory}
    OperatingSystem.Create File    ${path_answers_file}
    # (Créer un nouveau fichier à chaque fois pour ne pas écraser le précédent ???)
    OperatingSystem.Append To File    ${path_answers_file}    ${conversation}

Insert ChatGPT content in database
    [Documentation]    This keyword inserts the generated content, whatever a text or an image, in the database
    [Arguments]    ${chatgpt_content_to_insert_in_db}
#    verify if the db directory exists 
    Create Directory If Does Not Exist    ./database
#    verify if db exists, if not, create db with 2 tables ("texts" and "images" and 3 columns (test name, date, generated_content)
    Create Database If Does Not Exist    ./database/db_rf_chatgpt.db
#    if content starts with "https://" (url), so insert it in the tables "image"
    ${datetime}=    Get Current Date    result_format=%Y-%m-%d${SPACE}%H-%M-%S
    ${content_starts_with}=    Evaluate    "${chatgpt_content_to_insert_in_db}".startswith("https://")
    IF    ${content_starts_with} == True
        Execute Sql String    INSERT INTO images (test_name, datetime, content) VALUES('${TEST NAME}','${datetime}','${chatgpt_content_to_insert_in_db}');
    ELSE
        Execute Sql String    INSERT INTO texts (test_name, datetime, content) VALUES('${TEST NAME}','${datetime}','${chatgpt_content_to_insert_in_db}');
    END

Retrieve data in database with a string argument
    [Documentation]    The query must receive a string argument to select every row containing the researched word(s)
    [Arguments]    ${research}
    ${results}    Query    SELECT * FROM texts WHERE content LIKE '%${research}%';
    Log Many    ${results}
