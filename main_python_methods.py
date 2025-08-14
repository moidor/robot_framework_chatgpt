import os
from urllib.request import urlretrieve
from robot.api.deco import keyword, library
from robot.libraries.BuiltIn import BuiltIn


@library
class Main_python_methods:
    def __init__(self):
        self.selLib = BuiltIn().get_library_instance("SeleniumLibrary")

    @keyword
    def download_image(self, url, output_path):
        urlretrieve(url, output_path)

    @keyword
    def directory_exists(self, path):
        return os.path.isdir(path)

    @keyword
    def file_exists(self, path):
        return os.path.isfile(path)
