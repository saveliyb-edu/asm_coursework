#include <stdio.h>
#include <conio.h>

#define QUEUE_SIZE 10

typedef struct {
    int data[QUEUE_SIZE];
    int front;
    int rear;
    int count;
} Queue;

Queue queue = { {0}, 0, 0, 0 };

void enqueue(int value) {
    if (queue.count == QUEUE_SIZE) {
        printf("The queue is full!!\n");
        return;
    }

    queue.data[queue.rear] = value;

    queue.rear = (queue.rear + 1) % QUEUE_SIZE;

    queue.count++;

    printf("The %d element has been added to the queue\n", value);
}

int dequeue() {
    int value;

    if (queue.count == 0) {
        printf("The queue is empty!\n");
        return -1;
    }

    value = queue.data[queue.front];

    queue.front = (queue.front + 1) % QUEUE_SIZE;

    queue.count--;

    printf("The %d element has been removed from the queue\n", value);
    return value;
}

void printQueue() {
    int i;
    if (queue.count == 0) {
        printf("The queue is empty!\n");
        return;
    }

    printf("Queue contents: ");
    for (i = 0; i < queue.count; i++) {
        int index = (queue.front + i) % QUEUE_SIZE; 
        printf("%d ", queue.data[index]);
    }
    printf("\n");
}

void demo() {
    int choice, value;
    do {
        printf("\nMenu:\n");
        printf("1. Add an item\n");
        printf("2. Delete an item\n");
        printf("3. Print the queue\n");
        printf("4. Exit\n");
        printf("Select an action: ");
        scanf("%d", &choice);

        switch (choice) {
        case 1:
            printf("Enter a value: ");
            scanf("%d", &value);
            enqueue(value);
            break;
        case 2:
            value = dequeue();
            if (value != -1) {
                printf("Value removed: %d\n", value);
            }
            break;
        case 3:
            printQueue();
            break;
        case 4:
            printf("Exiting the program.\n");
            break;
        default:
            printf("Wrong choice, try again.\n");
        }
    } while (choice != 4);
}

int main() {
    demo();
    return 0;
}
