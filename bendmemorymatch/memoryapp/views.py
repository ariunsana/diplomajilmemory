from django.shortcuts import render
from rest_framework import viewsets
from rest_framework.response import Response
from .models import Player, Game
from .serializers import PlayerSerializer, GameSerializer
from rest_framework.decorators import api_view
from rest_framework.decorators import action

# Create your views here.

class PlayerViewSet(viewsets.ModelViewSet):
    queryset = Player.objects.all()
    serializer_class = PlayerSerializer

    @action(detail=False, methods=['get'], url_path='check-name/(?P<name>[^/.]+)')
    def check_name(self, request, name=None):
        exists = Player.objects.filter(name=name).exists()
        return Response({'exists': exists})

    def create(self, request, *args, **kwargs):
        # Check for duplicate name before creating
        name = request.data.get('name')
        if Player.objects.filter(name=name).exists():
            return Response(
                {'error': 'This name is already taken'},
                status=400
            )
        return super().create(request, *args, **kwargs)

class GameViewSet(viewsets.ModelViewSet):
    queryset = Game.objects.all()
    serializer_class = GameSerializer
