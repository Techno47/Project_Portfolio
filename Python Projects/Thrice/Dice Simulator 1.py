import random

def roll(min,max):
    while True:
        print("Rolling dice...")
        print(f"Your number is : {random.randint(min,max)}")
        choice = input("Do you want to roll the dice again? (y/n)")
        if choice == 'n':
            break
roll(1 , 6)



