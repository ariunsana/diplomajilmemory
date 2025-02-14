from django.contrib import admin
from .models import Player, GameType, Game, MemoryMatch, ChimpTest, SequenceMemory, VisualMemory, ReactionTime, VerbalMemory, NumberMemory, CartGame, Score

# Register your models here.
admin.site.register(Player)
admin.site.register(GameType)
admin.site.register(Game)
admin.site.register(MemoryMatch)
admin.site.register(ChimpTest)
admin.site.register(SequenceMemory)
admin.site.register(VisualMemory)
admin.site.register(ReactionTime)
admin.site.register(VerbalMemory)
admin.site.register(NumberMemory)
admin.site.register(CartGame)
admin.site.register(Score)
