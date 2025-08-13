*** Settings ***
Library    OperatingSystem    
Library    String
Resource    main_keywords.robot
Resource    my_variables.robot

*** Variables ***
# Insertion of my api key
${var_api_key}    ${my_api_key}

# Autre manière de créer une variable globale au projet (moins fiable que la variable ci-dessus)
# *** Tasks ***
# Set A Global API Variable
#     Set Global Variable    my_personal_api_key    

*** Keywords ***
Make sure that the API key is filled
    [Documentation]    We make sure that the API key is filled to connect to ChatGPT.
    [Tags]    api_key    filled_data    string_variable
    Should Not Be Empty    ${var_api_key}
    Should Be String    ${var_api_key}
    Log    The API key is filled as a string
