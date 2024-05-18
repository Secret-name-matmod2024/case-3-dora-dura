# Обучение робота паркуру (Учебник) #
Это учебник по обучению политики навыков и дистилляции политики паркура.

## Установка ##
1. Создайте новое виртуальное окружение Python или окружение conda с Python 3.6, 3.7 или 3.8 (рекомендуется 3.8)
2. Установите PyTorch 1.10 с поддержкой cuda-11.3:
    - pip install torch==1.10.0+cu113 torchvision==0.11.1+cu113 torchaudio==0.10.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html
3. Установите Isaac Gym
   - Скачайте и установите Isaac Gym Preview 4 (я не тестировал предыдущие версии) с https://developer.nvidia.com/isaac-gym
   - cd isaacgym/python && pip install -e .
   - Попробуйте запустить пример: cd examples && python 1080_balls_of_solitude.py
   - Для устранения неполадок смотрите документацию isaacgym/docs/index.html
4. Установите rsl_rl (реализация PPO)
   - Используйте команду для перехода в корневой каталог этого репозитория
   - cd rsl_rl && pip install -e . 
5. Установите legged_gym
   - cd ../legged_gym && pip install -e .

## Использование ##
*Всегда запускайте свой скрипт в корневом каталоге этой папки legged_gym (которая содержит файл setup.py).*

1. Специализированная политика навыков обучается с использованием a1_field_config.py как задачи a1_field

    Запустите команду: python legged_gym/scripts/train.py --headless --task a1_field
    
2. Дистилляция выполняется с использованием a1_field_distill_config.py как задачи a1_distill

    Дистилляция выполняется в многопроцессорном режиме. В общем, вам нужно как минимум 2 процесса, каждый с 1 GPU, и доступ к общей папке.

    Запустите команду: python legged_gym/scripts/train.py --headless --task a1_distill чтобы запустить тренер. Процесс предложит вам запустить процесс сбора данных, где каталог логов соответствует задаче.

    Запустите команду: python legged_gym/scripts/collect.py --headless --task a1_distill --load_run {ваш запуск обучения} чтобы запустить сборщик. Процесс загрузит обучающую политику и начнет сбор данных. Собранные данные будут сохранены в каталоге, указанном тренером. Удалите его после завершения дистилляции.

### Обучение политики ходьбы ###

Запустите обучение командой: python legged_gym/scripts/train.py --headless --task a1_field. Логи обучения можно найти в logs/a1_field. Название папки также является именем запуска.

### Обучение каждого отдельного навыка ###

- Запустите скрипт с задачами a1_climb, a1_leap, a1_crawl, a1_tilt. Логи обучения также будут сохранены в logs/a1_field.

- Обучение по умолчанию выполняется с мягким динамическим ограничением. Чтобы обучиться с жестким динамическим ограничением, измените значение virtural_terraion на False в соответствующем файле конфигурации.

    - Раскомментируйте часть класса sensor, чтобы включить задержку проприоцепции.

    - Для a1_climb обновите поле climb["depth"] при переключении на жесткое динамическое ограничение.

- Обязательно обновите поле load_run в соответствующем каталоге логов, чтобы загрузить политику с предыдущего этапа.

### Дистилляция политики паркура ###

Вам потребуется как минимум два GPU, которые могут рендерить в IsaacGym и имеют как минимум 24 ГБ памяти (обычно RTX 3090).

1. Обновите поле A1FieldDistillCfgPPO.algorithm.teacher_policy.sub_policy_paths с каталогом логов вашей обученной политики навыков. (в a1_field_distill_config.py)

2. Запустите сбор данных командой: python legged_gym/scripts/collect.py --headless --task a1_distill. Данные будут сохранены в каталоге logs/distill_{robot}_dagger.

    *Вы можете сгенерировать несколько наборов данных, запуская этот шаг несколько раз.*

    *Вы можете использовать символическую ссылку, чтобы поместить каталог logs/distill_{robot}_dagger на более быструю файловую систему для ускорения процесса обучения и сбора данных.*

3. Обновите поле A1FieldDistillCfgPPO.runner.pretrain_dataset.data_dir списком каталогов данных. Закомментируйте поле A1FieldDistillCfgPPO.runner.pretrain_dataset.scan_dir. (в a1_field_distill_config.py)
4. Запустите команду: python legged_gym/scripts/train.py --headless --task a1_distill чтобы начать дистилляцию. Логи дистилляции будут сохранены в logs/distill_{robot}.

5. Закомментируйте поле A1FieldDistillCfgPPO.runner.pretrain_dataset.data_dir и раскомментируйте поле A1FieldDistillCfgPPO.runner.pretrain_dataset.scan_dir. (в a1_field_distill_config.py)

6. Обновите поле A1FieldDistillCfgPPO.runner.load_run с последним логом дистилляции.

7. Запустите команду: python legged_gym/scripts/train.py --headless --task a1_distill чтобы начать dagger. Терминал предложит вам запустить процесс сборщика.

    Чтобы запустить процесс сборщика, измените RunnerCls на DaggerSaver (как в строках 20-21). Запустите команду: python legged_gym/scripts/collect.py --headless --task a1_distill --load_run {запуск обучения, предложенный тренировочным процессом}.

    *Вы можете запустить несколько процессов сборщиков для ускорения сбора данных. Следуйте комментариям в скрипте сборщика.*

    *Сборщики можно запускать на любой другой машине, пока каталоги logs/distill_{robot}_dagger и logs/distill_{robot} общие для них.*

    Нажмите Enter в тренировочном процессе, когда увидите, что некоторые данные собраны (подсказано процессом сборщика). Тренировочный процесс загрузит собранные данные и начнет обучение.

### Визуализация политики в симуляции ###

python legged_gym/scripts/play.py --task {task} --load_run {run_name}