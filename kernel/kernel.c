#include <kernel/monitor.h>

int main(struct multiboot *mboot_ptr)
{
    monitor_clear();

    monitor_write("Boot");

    return 0;
}