from html2image import Html2Image
import os


class Img:
    def __init__(self):
        start = False
        self.hti = Html2Image()
        self.hti = Html2Image(output_path='images')

    def convert_img(self):
        html = """<div class='box'>Hello, world!</div>"""
        css = ".box { color: white; background-color: #0f79b9; padding: 10px; font-family: Roboto }"
        self.hti.screenshot(html_str=html, css_str=css, save_as='red_page.png', size=(500, 500))
