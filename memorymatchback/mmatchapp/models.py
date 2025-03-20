from django.db import models

class Player(models.Model):
    username = models.CharField(max_length=50, unique=True)
    email = models.CharField(max_length=50, unique=True)
    passwd = models.CharField(max_length=50, unique=True)
    created_at = models.DateTimeField(auto_now_add=True)

class GameType(models.Model):
    name = models.CharField(max_length=50, unique=True)

class Game(models.Model):
    player = models.ForeignKey(Player, on_delete=models.CASCADE)
    game_type = models.ForeignKey(GameType, on_delete=models.CASCADE)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    score = models.IntegerField()
    completed = models.BooleanField(default=False)
    time_taken = models.IntegerField()

class MemoryMatch(models.Model):
    game = models.ForeignKey(Game, on_delete=models.CASCADE) 
    pairs_found = models.IntegerField()
    moves = models.IntegerField()
    time_taken = models.IntegerField()

class SequenceMemory(models.Model):
    game = models.ForeignKey(Game, on_delete=models.CASCADE)
    highest_level = models.IntegerField()
    time_taken = models.IntegerField()

class CartGame(models.Model):
    game = models.ForeignKey(Game, on_delete=models.CASCADE)
    items_collected = models.IntegerField()
    time_taken = models.IntegerField()
    highest_level = models.IntegerField()
    picture = models.BinaryField()  # To store the picture in binary format

class Score(models.Model):
    player = models.ForeignKey(Player, on_delete=models.CASCADE)
    game_type = models.ForeignKey(GameType, on_delete=models.CASCADE)
    score = models.IntegerField()
    date = models.DateTimeField(auto_now_add=True)
