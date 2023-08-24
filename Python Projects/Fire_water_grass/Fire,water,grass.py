import random

print("Welcome to the Arena, Player!")

def game():
    max_damage = 50
    min_damage = 5
    max_hp = 100

    player_hp = max_hp
    cpu_hp = max_hp

    while player_hp > 0 and cpu_hp > 0:
        print("Player HP:", player_hp)
        print("CPU HP:", cpu_hp)
        player = input("=> Choose your move: Fire, Water, Grass or Run? ").lower()
        cpu = random.choice(["fire", "water", "grass"])

        if player == "run":
            print("You ran away...")
            print("CPU WINS the game!")
            break

        print("CPU chose:", cpu)
        if player == cpu:
            print("DRAW!")

        elif player == "fire":
            if cpu == "water":
                damage = random.randrange(min_damage - 5, max_damage - 10)
                player_hp -= damage
                print(f"Player takes {damage} damage. CPU WINS!")

            else:
                damage = random.randrange(min_damage - 5, max_damage - 10)
                cpu_hp -= damage
                print(f"CPU takes {damage} damage. PLAYER WINS!")

        elif player == "water":
            if cpu == "grass":
                damage = random.randrange(min_damage + 10, max_damage - 20)
                player_hp -= damage
                print(f"Player takes {damage} damage. CPU WINS!")

            else:
                damage = random.randrange(min_damage + 10, max_damage - 20)
                cpu_hp -= damage
                print(f"CPU takes {damage} damage. PLAYER WINS!")

        elif player == "grass":
            if cpu == "fire":
                damage = random.randrange(min_damage, max_damage - 35)
                player_hp -= damage
                print(f"Player takes {damage} damage. CPU WINS!")

            else:
                damage = random.randrange(min_damage, max_damage - 35)
                cpu_hp -= damage
                print(f"CPU takes {damage} damage. PLAYER WINS!")

        else:
            print("Invalid choice. Please enter Fire, Water, Grass or Run!")

    if player_hp <= 0:
        print("Player has fainted... CPU WINS the game!")
    elif cpu_hp <= 0:
        print("CPU has fainted... PLAYER WINS the game!")

game()


