#ifndef OS_MONITOR_H
#define OS_MONITOR_H

#pragma once

#include <kernel/common.h>

void monitor_put(char c);
void monitor_clear();
void monitor_write(char *c);

#endif