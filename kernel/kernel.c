#include <kernel/monitor.h>

int main()
{
    monitor_clear();

    monitor_write("Boot");

    return 0;
}