#ifndef DEF_H
#define DEF_H

#define DISABLE_COPY(ClassName) \
    ClassName(const ClassName&) = delete; \
    ClassName& operator=(const ClassName&) = delete

#endif // DEF_H

