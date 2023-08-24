import random 
import tkinter 
from tkinter import *

die = tkinter.Tk()
die.geometry("550x360")
die.title("Dice Simulator")
die.configure(bg="black")
die.resizable(0, 0)

l1 = Label(die, font=("times", 210), fg="yellow2", bg="black")

def roll():
    picture =["\u2680", "\u2681", "\u2682", "\u2683", "\u2684", "\u2685"]
    l1.config(text=f"{random.choice(picture)}{random.choice(picture)}")
    l1.pack(expand=True)

roll_button = tkinter.Button(die, text="Roll it up!", width = 15, height= 2, 
font =("calibri bold", 13), fg="white", bg="crimson", command=roll)
roll_button .pack(padx=10, pady=15)  

die.mainloop()

