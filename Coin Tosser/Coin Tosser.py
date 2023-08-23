import random

def cointoss():     
    return random.choice(["HEADS", "TAILS"])
while True:  
  choice = input("You wanna toss a coin? (y/n)")
  if choice == 'y':
   print('Tossing coin....') 
   print("Your result is" , cointoss())
  elif choice == 'n':
     break

  
   





