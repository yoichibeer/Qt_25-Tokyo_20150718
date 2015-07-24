#include "domcomparetest.h"

#include <QFile>

#include <QDomDocument>
#include <QDomElement>
#include <QDomText>

#include <QTextStream>

#include <QDebug>

void DomCompareTest::test() const
{
    QDomDocument documentMemory;
    {
        QDomElement foo = documentMemory.createElement( "foo" );
        foo.setAttribute( "name", "FooName" );

        QDomElement bar = documentMemory.createElement( "bar" );
        bar.setAttribute( "name", "BarName" );

        QDomText text = documentMemory.createTextNode( "Some text" );

        QDomElement yoichi = documentMemory.createElement( "yoichi" );
        QDomText kara = documentMemory.createTextNode( "" );
        yoichi.appendChild( kara );

        documentMemory.appendChild( foo );
        foo.appendChild( bar );
        foo.appendChild( text );
        foo.appendChild( yoichi );

        QFile file( "simple.xml" );
        if( !file.open( QIODevice::WriteOnly | QIODevice::Text ) )
        {
          qDebug( "Failed to open file for writing." );
          return;
        }

        QTextStream stream( &file );
        stream << documentMemory.toString();

        file.close();
    }

    {
        QFile inFile( "simple.xml" );
        if( !inFile.open( QIODevice::ReadOnly | QIODevice::Text ) )
        {
          qDebug( "Failed to open file for reading." );
          return;
        }

        QDomDocument documentFile;
        if( !documentFile.setContent( &inFile ) )
        {
          qDebug( "Failed to parse the file into a DOM tree." );
          inFile.close();
          return;
        }

        inFile.close();

        qDebug() << documentMemory.toString();
        qDebug() << documentFile.toString();

        qDebug() << "----------";

        documentMemory.normalize();
        documentFile.normalize();

        if (documentMemory.documentElement() == documentFile.documentElement())
        {
            qDebug() << "一致";
        }
        else
        {
            qDebug() << "不一致";
        }

        qDebug() << documentMemory.toString();
        qDebug() << documentFile.toString();

        QDomElement documentElement = documentFile.documentElement();
        QDomNodeList elements = documentElement.elementsByTagName( "bar" );
        if( elements.size() == 0 )
        {
          QDomElement bar = documentFile.createElement( "bar" );
          documentElement.insertBefore( bar, QDomNode() );
        }
        else if( elements.size() == 1 )
        {
          QDomElement bar = elements.at(0).toElement();

          QDomElement baz = documentFile.createElement( "baz" );
          baz.setAttribute( "count", QString::number( bar.elementsByTagName( "baz" ).size() + 1 ) );

          bar.appendChild( baz );
        }

        QFile outFile( "simple-modified.xml" );
        if( !outFile.open( QIODevice::WriteOnly | QIODevice::Text ) )
        {
          qDebug( "Failed to open file for writing." );
          return;
        }

        QTextStream stream( &outFile );
        stream << documentFile.toString();

        outFile.close();
    }
}
