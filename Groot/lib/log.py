from imports import *


class log:

    def __init__(self):
        self.name = 'log'

    def log_save(self, today, text, folder):
        count = len(os.listdir(f'./logs/{folder}'))
        test = True
        if count == 0:
            f = open(f"./logs/{folder}/{today}.txt", "x")
            f.close()
        else:
            for filename in os.listdir(f'./logs/{folder}'):
                if filename.endswith('.txt'):
                    if str(filename[:-4]) == str(today):
                        test = False

        if test:
            f = open(f"./logs/{folder}/{today}.txt", "x")
            f.close()

        with open(f"./logs/{folder}/{today}.txt", 'a') as f:
            print(text)
            f.write(text + "\n")
