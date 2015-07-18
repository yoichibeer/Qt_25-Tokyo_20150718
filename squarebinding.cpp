#include "squarebinding.h"

#include <QDebug>

SquareBinding::SquareBinding()
    : x_(200)
    , y_(50)
{
}



double SquareBinding::x() const
{
    return x_;
}
void SquareBinding::setX(double x)
{
//    if (x_ == x)
//    {
//        return;
//    }

    qDebug() << __FUNCTION__ << x;

    x_ = x;
    emit xChanged();
}

double SquareBinding::y() const
{
    return y_;
}
void SquareBinding::setY(double y)
{
//    if (y_ == y)
//    {
//        return;
//    }

    y_ = y;
    emit yChanged();
}
