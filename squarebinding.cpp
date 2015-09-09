#include "squarebinding.h"

#include <QTimer>
#include <QDebug>



Position::Position()
    :x_(200), y_(50)
{
    timer_.start(1000);
    connect(&timer_, SIGNAL(timeout()), this, SLOT(update()));
}

double Position::getX() const { return x_; }
void Position::setX(double x) { x_ = x; }

double Position::getY() const { return y_; }
void Position::setY(double y) { y_ = y; }

void Position::update()
{
    x_ += 10.123456789; if (x_ > 200) x_ = 0;
    y_ += 10.987654321; if (y_ > 200) y_ = 0;
    emit updated();
}


SquareBinding::SquareBinding()
{
    connect(&position_, SIGNAL(updated()), this, SLOT(updatePosition()));
}


QString SquareBinding::x() const
{
    return QString::number(position_.getX(), 'f', 2);
}
void SquareBinding::setX(QString xStr)
{
    if (x() == xStr)
    {
        return;
    }

    qDebug() << __FUNCTION__ << xStr;

    position_.setX(xStr.toDouble());

    emit xChanged();
}

QString SquareBinding::y() const
{
    return QString::number(position_.getY(), 'f', 2);;
}
void SquareBinding::setY(QString yStr)
{
    if (y() == yStr)
    {
        return;
    }

    qDebug() << __FUNCTION__ << yStr;

    position_.setY(yStr.toDouble());

    emit yChanged();
}

void SquareBinding::updatePosition()
{
    emit xChanged();
    emit yChanged();
}
