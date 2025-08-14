*** Settings ***
Documentation       To execute a test case using a tag, write this command in the terminal :robot -d results -i Smoke Tests/Tags.robot
...                 For further information: https://testersdock.com/robot-framework-tags/
Library             RPA.OpenAI
Library             String
Library             OperatingSystem
Library             Screenshot
Library             Dialogs
Resource            chatgpt_keywords.robot
Resource            image_chatgpt.robot
Resource            main_keywords.robot
Test Setup          Make sure that the API key is filled
Suite Setup         Connect to SQLiteDB
Suite Teardown      Disconnect From Database


*** Variables ***
@{chatgpt_conversation}             @{EMPTY}
${path_text_file_conversation}      ${EXECDIR}/chatgpt_conversations/conversations.txt
${path_image_description}           ${EXECDIR}/chatgpt_conversations/image_description.txt


*** Test Cases ***
Create a conversation from a text file to insert the answer in another text file
    [Documentation]    A conversation in ChatGPT from a text file on the hard disk
    [Tags]    chatgpt_txt_file
    ${text_file_conversation}    Open file with conversation    ${path_text_file_conversation}
    ${conversation_content}    Asking ChatGPT
    ...    @{chatgpt_conversation}\[]
    ...    Integrate emojis in the answer \n${text_file_conversation}
    # Getting the content of the answer from the object. INFO: ChatGPT API does not provide links neither create files
    ${content_entire_conversation}    Set Variable    ${conversation_content}[0][1][content]
    ${result_content}    Convert To String    ${content_entire_conversation}
    Copy of the conversation in a text file    ${result_content}    docx
    Insert ChatGPT Content In Database    ${result_content}


Create a conversation from a text file with a generated image in the end
    [Documentation]    A conversation with a generated image in the end
    [Tags]    chatgpt
    ${text_file_conversation}    Open file with conversation    ${path_text_file_conversation}
    ${conversation_content}    Asking ChatGPT
    ...    @{chatgpt_conversation}\[]
    ...    Integrate emojis in the answer \n${text_file_conversation}
    Generate an image    ${conversation_content}


Create a conversation from a text file then googling it
    [Documentation]    A conversation with a Google research in the end
    [Tags]    google    chatgpt
    ${text_file_conversation}    Open file with conversation    ${path_text_file_conversation}
    ${conversation_content}    Asking ChatGPT
    ...    @{chatgpt_conversation}\[]
    ...    ${text_file_conversation}
    Research on Google    ${conversation_content}[0][1][content]


Generate an image
    Generate An Image    A humpback whale alongside Waikiki Beach with the Diamond Head


Generate an image with a Robot Framework template
    [Documentation]    Using the official "template" keyword, only the description in argument is required
    [Tags]    template    image
    [Template]    Generate an image
    Beach with tropical water and a kayak and a coconut floating on the water.
    A cute red panda in a tree.
    A prehistoric giant bird flying above Nan Madol, Micronesia.


Generate an image from a text file
    ${image_url}    Generate An Image From A Text File    ${path_image_description}
    Insert ChatGPT Content In Database    ${image_url}

        
Launching one or several tag tests from a command line
    [Documentation]    Here we launch the test(s) based on the following tag "chatgpt_txt_file"
    Launch A Test With A Command Line    robot -d results -i chatgpt_txt_file chatgpt_test_cases.robot

Retrieve data in "texts" table
    Retrieve Data In Database With A String Argument    a string argument    archipelago
