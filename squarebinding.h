#ifndef SQUARE_H
#define SQUARE_H

#include <QObject>

class SquareBinding : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double x READ x WRITE setX NOTIFY xChanged)
    Q_PROPERTY(double y READ y WRITE setY NOTIFY yChanged)

public:
    explicit SquareBinding();
    ~SquareBinding() = default;

    double x() const;
    void setX(double x);

    double y() const;
    void setY(double y);

signals:
    void xChanged();
    void yChanged();

private:
    double x_;
    double y_;

    SquareBinding(const SquareBinding&) = delete;
    SquareBinding& operator=(const SquareBinding&) = delete;
};

#endif // SQUARE_H
