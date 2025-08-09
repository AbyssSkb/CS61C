#include "ll_cycle.h"
#include <stddef.h>

int ll_has_cycle(node* head)
{
    node* tortoise = head;
    node* hare = NULL;
    if (head == NULL) {
        return 0;
    }
    hare = head->next;

    while (hare != NULL) {
        hare = hare->next;
        if (hare == NULL) {
            break;
        }
        tortoise = tortoise->next;
        hare = hare->next;
        if (tortoise == hare) {
            return 1;
        }
    }
    return 0;
}
