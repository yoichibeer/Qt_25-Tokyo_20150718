#ifndef SQUARE_H
#define SQUARE_H

#include <QTimer>
#include <QObject>
#include "defs.h"

class Position : public QObject
{
    Q_OBJECT
public:
    Position();
    ~Position() = default;

    double getX() const;
    void setX(double x);

    double getY() const;
    void setY(double y);

signals:
    void updated();

public slots:
    void update();

private:
    double x_;
    double y_;

    QTimer timer_;

    DISABLE_COPY(Position);
};

class SquareBinding : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(QString y READ y WRITE setY NOTIFY yChanged)

public:
    explicit SquareBinding();
    ~SquareBinding() = default;

    QString x() const;
    void setX(QString xStr);

    QString y() const;
    void setY(QString yStr);

signals:
    void xChanged();
    void yChanged();
public slots:
    void updatePosition();

private:
//    QString xStr_;
//    QString yStr_;

    Position position_;

    DISABLE_COPY(SquareBinding);
};

#endif // SQUARE_H
