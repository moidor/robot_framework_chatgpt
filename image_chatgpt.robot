*** Settings ***
Library     RPA.OpenAI
Library     Screenshot
Library     SeleniumLibrary
Library     main_python_methods.py
Library     DateTime
Resource    open_pictures_in_webbrowser.robot
Resource    api_key.robot
Resource    my_variables.robot
Resource    chatgpt_keywords.robot


*** Keywords ***
Generate an image
    [Documentation]    Generation of an image taking a description in arguments or
    ...    based on the summarized description from the conversation
    [Tags]    image    image_generation
    [Arguments]    ${image_description}
    Authorize To OpenAI    api_key=${my_api_key}
    ${images}    Image Create
    ...    ${image_description}
    ...    size=256x256
    ...    num_images=1
    FOR    ${url}    IN    @{images}
        Log    ${url}
        Open picture in browser    ${url}
        ${image_url}=    Get Element Attribute    xpath=//img    src
        Log    ${image_url}
        Page should contain image  ${image_url}
        Create Directory If Does Not Exist    ./images
        ${datetime}=    Get Current Date    result_format=%Y-%m-%d_%H-%M-%S
        Download Image    ${image_url}    images/img_chatgpt_${datetime}-${TEST NAME}.jpg
        Take Screenshot    screenshots/my_screenshot_1.jpg    100%
    END


Generate an image from a text file
    [Documentation]    Generation of an image taking a description in arguments from a text file
    [Tags]    image    image_generation
    [Arguments]    ${path_text_file_conversation}
    Authorize To OpenAI    api_key=${my_api_key}
    ${image_description_from_txt_file}    Open file with conversation    ${path_text_file_conversation}
    @{images}    Image Create
    ...    ${image_description_from_txt_file}
    ...    size=256x256
    ...    num_images=1
    FOR    ${url}    IN    @{images}
        Log    ${url}
        Open picture in browser    ${url}
        ${image_url}=    Get Element Attribute    xpath=//img    src
        Log    ${image_url}
        Page should contain image  ${image_url}
        Create Directory If Does Not Exist    ./images
        ${datetime}=    Get Current Date    result_format=%Y-%m-%d${SPACE}%H-%M-%S
        Download Image    ${image_url}    images/${datetime}-${TEST NAME}.jpg
        Take Screenshot    screenshots_txt_file/my_screenshot_1.jpg    100%
        RETURN    ${image_url}
    END

