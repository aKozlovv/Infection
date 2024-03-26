# infection app
![Cover](https://github.com/aKozlovv/Infection/assets/154222268/12135307-e875-424c-855c-744feeb4dee5)
# Исходные
Нужно разработать iOS-приложение, которое симулирует и визуализирует распространение инфекции в группе людей.

Приложение должно включать два экрана:  
• экран ввода параметров,  
• экран визуализации моделирования.

## Архитектура
Приложение реализовано на основе паттерна MVC. Каждый экран разделен на два модуля: Controller и View.

В каждом из экранов:
1. Controller отвечает за работу с данными, навигацию, вычисления.
2. View отвечает за UI элементы и их layout, обновление.

Для работы всего приложения предусмотрена Model - Person, которая представляет из себя одного "человека", который может быть заражен.

## Симуляция

Экран симуляции представляет из себя collectionView с использованием CompositionalLayout, которая адаптируется под Zoom.

Коллекция наполняется объектами Person в соответствии с заданным размером группы.

Все вычисления происходят внутри SimulationController. Симуляция условно разделена на методы:

    func performSimulation()
 - отвечает за работу с потоками и "пробегается" по индексам уже зараженных людей и вызывает для них метод заражения соседей.


    
`func  infectNeighbors(near index: Int)`
 - вызывает метод для поиска соседей текущего человека, ставит NSLock и пытается заразить конкретного соседа, если заражение удачно, то добавляет индексы в массив для обновления интерфейса.
 
 `func getNeighbors(of index: Int) -> [Int] `
 - метод обходит массив координат предполагаемых соседей. Координаты соответствуют потенциальным 7 соседям. После того как метод находит координаты всех возможных соседей, он отдает случайные индексы найденных соседей, но не больше чем установленное ограничение - infectionRate.

Процесс симуляции заражения происходит в DispatchQueue.global с установленным default qos.

Все обновление UI происходит в main потоке для конкретных ячеек коллекции по их индексам при помощи метода collectionView - `reconfigureItems()`