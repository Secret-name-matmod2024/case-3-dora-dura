# Обучаем Дору делать SWAG #

## Архитектура для пидораса ##
* `legged_gym`: Качаться жетска тут.
    - `legged_gym/legged_gym/envs/a1/`: Конфиги для тренировки Доры и ее ебыря.
    - `legged_gym/legged_gym/envs/base/`: Ну это база чел.
    - `legged_gym/legged_gym/utils/terrain/`: Генерация террейна.
* `rsl_rl`: Алгоритмы и сети. Мы где-то прочли что эту хуйню можно прям в собаку вставить (ток пж с помощью защищенных флешек а то щенки это дорого).
    - `rsl_rl/rsl_rl/algorithms/`: Алгоритмы.
    - `rsl_rl/rsl_rl/modules/`: Сети.
 
## Обучение в симуляции ##
Мы крч не хотели все на локалке делать мы люди адекватные, поэтому запускаешь все это в контейнере с помощью `run.sh`. Далее `pip install -e rsl_rl/ && pip install -e legged_gym` и кайфуешь епта.
Обучаешь вот так вот `python legged_gym/legged_gym/scripts/train.py` Увидишь окошечко со сценой обучения и кайфууууешь как рок бой.

## Деплой на собаку ##
Очко свое задеплой [Deploy.md](Deploy.md).

# Шутки от Алексея #

```
- Как называется когда две собаки едут на электросамокате
- Поездка в шоколадницу
```

```
Контекст - порнхаб
- У нас таких фантазий нет у нас есть сестры
```

```
Дудка хотабыча туда дуй оттуда хуй
```

```
Валера ебнутый а я ебанутый
```

```
Я был белым пятном на фотографии на фоне одноклассников из-за различия цвета кожи
```

```
Леша выбирай дальше слова аккуратнее мы РИДМИ пишем
```