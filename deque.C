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

    asm{
        mov bx, OFFSET queue
        mov ax,[bx + 2]
        inc ax
        mov cx, QUEUE_SIZE
        xor dx, dx
        div cx
        mov[bx + 2], dx
    }

    queue.data[queue.rear] = value;
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

    asm{
        mov bx, OFFSET queue
        mov ax,[bx]
        inc ax
        mov cx, QUEUE_SIZE
        xor dx, dx
        div cx
        mov[bx], dx
    }

    queue.count--;
    printf("The %d element has been removed from the queue\n", value);
    return value;
}


void demo() {
    int choice, value;
    do {
        printf("\nMenu:\n");
        printf("1. Add an item\n");
        printf("2. Delete an item\n");
        printf("3. Exit\n");
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
            printf("Exiting the program.\n");
            break;
        default:
            printf("Wrong choice, try again.\n");
        }
    } while (choice != 3);
}

int main() {
    demo();
    return 0;
}
