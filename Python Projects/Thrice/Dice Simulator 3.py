import tkinter
from PIL import Image,ImageTk
import random

root=tkinter.Tk()
root.geometry('400x400')
root.title("Dice Sim")
root.configure(bg='lightblue1')

dice = [r'Thrice\die1.PNG', r'Thrice\die2.PNG', r'Thrice\die3.PNG',
 r'Thrice\die4.PNG', r'Thrice\die5.PNG', r'Thrice\die6.PNG']

image1=ImageTk.PhotoImage(Image.open(random.choice(dice)))
label1=tkinter.Label(root,image=image1)
label1.image=image1
label1.pack(expand=True)

def roll():
    image1=ImageTk.PhotoImage(Image.open(random.choice(dice)))
    label1.configure(image=image1)
    label1.image=image1

button=tkinter.Button(root,text="Roll the Dice!!!", width = 18, 
height = 2, font =("calibri bold", 12), fg="snow", bg="crimson", command=roll)
button.place(x=250, y=0)
button.pack(expand=True)

root.mainloop()
