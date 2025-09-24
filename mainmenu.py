import pygame

pygame.init()
screen = pygame.display.set_mode((1280, 720))
clock = pygame.time.Clock()
FPS = 60
running = True
pygame.display.set_caption("Mainmenu")
BG = (50,50,50)
icon = pygame.image.load("assets/icon1.png")

while running:
    # poll for events
    # pygame.QUIT event means the user clicked X to close your window
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

    # fill the screen with a color to wipe away anything from last frame
    #screen.fill(BG2)
    screen.fill(BG)
    pygame.display.set_icon(icon)
    # RENDER YOUR GAME HERE
    pygame.display.update()
    # flip() the display to put your work on screen
    pygame.display.flip()

    clock.tick(FPS)  # limits FPS to 60

pygame.quit()