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

    @action(detail=True, methods=['patch'])
    def update_level(self, request, pk=None):
        try:
            player = self.get_object()
            new_level = request.data.get('level')
            new_score = request.data.get('score')
            
            if new_level is not None:
                player.level = new_level
            if new_score is not None:
                player.score = new_score
                
            player.save()
            return Response({
                'message': 'Level and score updated successfully',
                'level': player.level,
                'score': player.score
            })
        except Player.DoesNotExist:
            return Response({'error': 'Player not found'}, status=404)
        except Exception as e:
            return Response({'error': str(e)}, status=500)

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
