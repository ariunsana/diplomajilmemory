from django.db import models

class Player(models.Model):
    name = models.CharField(max_length=100)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.name

class Game(models.Model):
    GAME_TYPES = [
        ('CARD_GAME', 'Хөзрийн тоглоом'),
        ('SEQUENCE_GAME', 'Харааны санах ой'),
        ('CHIMP_TEST', 'дараалалын санах ой'),
    ]
    
    player = models.ForeignKey(Player, on_delete=models.CASCADE, related_name='games')
    game_type = models.CharField(max_length=20, choices=GAME_TYPES)
    game_name = models.CharField(max_length=100, default='Memory Match')
    score = models.IntegerField()
    played_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-played_at']  # Orders games by most recent first

    def __str__(self):
        return f"{self.player.name}'s {self.get_game_type_display()} - Score: {self.score}"
