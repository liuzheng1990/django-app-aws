from typing import Any
from django.db import models
from django.shortcuts import render
from django.views.generic import ListView, DetailView
from .models import Question, Choice


class QuestionListView(ListView):
    model = Question
    object_list = Question.objects.order_by("-pub_date")


class QuestionDetailView(DetailView):
    model = Question
