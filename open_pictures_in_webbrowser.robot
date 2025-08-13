*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${url}

*** Keywords ***
Open picture in browser
    [Documentation]    Call of the browser driver so that to open the url in a maximized window
    [Tags]    browser    webdriver
    [Arguments]    ${url}
    # Avec un keyword appelant le keyword "Create Webdriver"
    # Create a local webdriver    $url
    SeleniumLibrary.Open Browser    ${url}    Chrome
    Maximize Browser Window
    Get Window Titles    CURRENT
    Log To Console    Opened picture in the browser at this url : ${url}
