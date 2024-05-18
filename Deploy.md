## Установка зависимостей на роботе A1
Чтобы развернуть обученную модель на роботе Unitree A1, выполните следующие шаги:

1. Создайте папку на вашем роботе, например, `parkour`, и скопируйте в неё папку `rsl_rl`. Затем распакуйте файлы из `a1_ckpts` в папку `parkour`. Наконец, скопируйте все файлы из `onboard_script` в папку `parkour`.

2. Установите ROS и [пакет ROS для робота A1](https://github.com/unitreerobotics/unitree_ros.git). Следуйте инструкциям для настройки робота.

    Предположим, что рабочее пространство ROS находится в `parkour/unitree_ws`.

3. Установите PyTorch в Python 3 окружении. (Возьмите виртуальное окружение Python 3 на Nvidia Jetson NX в качестве примера)

    ```bash
    sudo apt-get install python3-pip python3-dev python3-venv
    python3 -m venv parkour_venv
    source parkour_venv/bin/activate
    ```

    Загрузите файл колеса pip отсюда [ссылка](https://forums.developer.nvidia.com/t/pytorch-for-jetson/72048) с версией 1.10.0. Затем установите его с помощью:

    ```bash
    pip install torch-1.10.0-cp36-cp36m-linux_aarch64.whl
    ```

4. Установите другие зависимости и `rsl_rl`:

    ```bash
    pip install numpy==1.16.4 numpy-ros
    pip install -e ./rsl_rl
    ```

## Запуск модели на A1

***Отказ от ответственности:*** *Всегда используйте ремень безопасности на роботе при его движении. Робот может упасть и нанести вред себе или окружающей среде.*

1. Положите робота на землю, включите его и убедитесь, что он находится в режиме разработчика.

2. Запустите три терминала на борту (либо три соединения SSH с вашего компьютера или что-то еще), назовите их T_ros, T_visual, T_gru.

3. В T_ros выполните:

    ```bash
    cd parkour/unitree_ws
    source devel/setup.bash
    roslaunch unitree_legged_real a1_bringup.launch
    ```

    Это запустит узел ROS для робота A1. Обратите внимание, что без установки `dry_run:=False` робот не будет двигаться. Установите `dry_run:=False` только тогда, когда будете готовы дать роботу двигаться.

4. В T_visual выполните:

    ```bash
    cd parkour
    source unitree_ws/devel/setup.bash
    source parkour_venv/bin/activate
    python a1_visual_embedding.py --logdir Nov02...
    ```

    где `Nov02...` - это logdir обученной модели.

    Дождитесь завершения загрузки модели и доступа к камере RealSense. Затем скрипт попросит вас: `"Realsense frame received. Sending embeddings..."`

    Добавление опции `--enable_vis` активирует сообщение о глубинном изображении как ROS топик. Вы можете визуализировать изображение глубины в RViz.

5. В T_gru выполните:

    ```bash
    cd parkour
    source unitree_ws/devel/setup.bash
    source parkour_venv/bin/activate
    python a1_ros_run.py --mode upboard --logdir Nov02...
    ```

    где `Nov02...` - это logdir обученной модели.

    Если узел ROS запущен с `dry_run:=False`, робот начнет вставать. В противном случае добавьте опцию `--debug` к `a1_ros_run.py`, чтобы видеть вывод модели.

    Если узел ROS запущен с `dry_run:=False`, скрипт запросит вас: `"Robot stood up! Press R1 on the remote control to continue..."` Нажмите R1 на пульте дистанционного управления, чтобы начать политику стояния.

    Нажатие R-Y вперед на пульте дистанционного управления вызовет политику паркура. Робот начнет бегать и прыгать. Отпустите джойстик, чтобы остановить робота.

    Нажмите R2 на пульте дистанционного управления, чтобы выключить скрипт GRU и узел ROS. Вы также можете использовать его в случае чрезвычайной ситуации.

    Используйте опцию `--walkdir`, чтобы загрузить политику ходьбы (например, Oct24_16...). Политика стояния будет заменена политикой ходьбы. Затем вы можете использовать L-Y, L-X для управления скоростью по осям x/y робота и использовать R-X для управления скоростью поворота робота.