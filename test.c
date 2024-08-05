#include <stdatomic.h>
#include <pthread.h>
#include <stdio.h>
#include <stdbool.h>

typedef struct {
    _Atomic int locked;
} Mutex;

void mutex_init(Mutex* mtx) {
    atomic_store(&mtx->locked, 0);
}

void mutex_lock(Mutex* mtx) {
    int expected = 0;
    while (!atomic_compare_exchange_weak(&mtx->locked, &expected, 1)) {
        expected = 0;
        // Busy wait
    }
}

void mutex_unlock(Mutex* mtx) {
    atomic_store(&mtx->locked, 0);
}

int shared_resource = 0;
Mutex lock;

void* thread_function(void* arg) {
    for (int i = 0; i < 10; i++) {
        mutex_lock(&lock);

        // Critical section
        shared_resource++;
        printf("Shared resource: %d\n", shared_resource);

        mutex_unlock(&lock);
    }
    return NULL;
}

int main() {
    pthread_t threads[2];
    mutex_init(&lock);

    for (int i = 0; i < 2; i++) {
        pthread_create(&threads[i], NULL, thread_function, NULL);
    }

    for (int i = 0; i < 2; i++) {
        pthread_join(threads[i], NULL);
    }

    return 0;
}