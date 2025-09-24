import pygame
import sys

from button import Button

pygame.init()
screen = pygame.display.set_mode((1280, 720))
clock = pygame.time.Clock()
FPS = 60
running = True
BG = pygame.image.load("assets/faith-spark-background1.jpg")
icon = pygame.image.load("assets/icon1.png")

def get_font(size):
    return pygame.font.SysFont("cambria", size)
def main_menu():
    pygame.display.set_caption("Mainmenu")
    while running:
        clock.tick(FPS)
        pygame.display.set_icon(icon)
        Exit_Button = Button(image=pygame.image.load("assets/button.png"), pos=(640,200),text_input="Exit",font=get_font(100),base_color="White",hovering_color="Green")
        Menu_mouse = pygame.mouse.get_pos()
        screen.blit(BG,(0,0))
        
        for button in [Exit_Button]:
            button.changeColor(Menu_mouse)
            button.update(screen)
        
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                pygame.quit()
                sys.exit()
            if event.type == pygame.MOUSEBUTTONDOWN:
                if Exit_Button.checkForInput(Menu_mouse):
                    pygame.quit()
                    sys.exit()
        
        button.update(screen)
        pygame.display.update()
main_menu()