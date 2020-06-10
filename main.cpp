/*
 * Intel architecture project - Computers' architecture
 * @author: Adam Stec
 * drawing a 3rd degree polynomial
*/

#include <iostream>
#include <GL/glut.h>
#include <string.h>
#include "f.hpp"

void keyboardCallback( unsigned char, int, int );
void redraw();
void setParams();
void displayCallback();

// global variables and constanst

const int width = 600;
const int height = 600;
const int BPP = 4;
const int delta = 1;

unsigned char* pixels = 0;

long long jump = 0;
long long c3 = 0, c2 = 0, c1 = 0, c0 = 0; //coefs of polynomial



int main(int argc, char** argv )
{
    pixels = new unsigned char[ width * height * BPP ];
    glutInit( &argc, argv );
    glutInitDisplayMode( GLUT_SINGLE );
    glutInitWindowSize( width, height );
    glutInitWindowPosition( 100, 100 );
    glutCreateWindow( "Intel architecture project" );
    glutSetKeyRepeat( GLUT_KEY_REPEAT_OFF );
    glutDisplayFunc( displayCallback );
    glutKeyboardFunc( keyboardCallback );
    setParams();
    glutSwapBuffers();
    glutMainLoop();
    delete[] pixels;
    return 0;
}

void displayCallback(){
    redraw();
    //std::cout << "Chart redrawed" << std::endl;
}

void redraw(){
    f( pixels, width, height, jump, c3, c2, c1, c0 );
    glDrawPixels( width, height, GL_RGBA, GL_UNSIGNED_BYTE, pixels );
    glutSwapBuffers();
}

enum KeyInput { _jump = 1, _c3, _c2, _c1, _c0 } input = _jump;

void keyboardCallback( unsigned char key, int x, int y ){

    if( key == '1' ){
        input = _jump;
        setParams();
    }
    if( key == '2' ){
        input = _c3;
        setParams();
    }
    if( key == '3' ){
        input = _c2;
        setParams();
    }
    if( key == '4' ){
        input = _c1;
        setParams();
    }
    if( key == '5' ){
        input = _c0;
        setParams();
    }
    else {
        switch( input ){
            case _jump:
                if( key == 'p' )
                    jump -= delta;
                else if( key == 'v' )
                    jump += delta;
                break;
            case _c3:
                if( key == 'p' )
                    c3 -= delta;
                else if( key == 'v' )
                    c3 += delta;
                break;
            case _c2:
                if( key == 'p' )
                    c2 -= delta;
                else if( key == 'v' )
                    c2 += delta;
                break;
            case _c1:
                if( key == 'p' )
                    c1 -= delta;
                else if( key == 'v' )
                    c1 += delta;
                break;
            case _c0:
                if( key == 'p' )
                    c0 -= delta;
                else if( key == 'v' )
                    c0 += delta;
                break;
        }
    }
    setParams();
    redraw();
}

void setParams(){
    system( "clear" );
    std::cout << "press 1 to set jump " << std::endl <<
                 "press 2 to set 3rd degree coef" << std::endl <<
                 "press 3 to set 2nd degree coef" << std::endl <<
                 "press 4 to set 1st degree coef" << std::endl <<
                 "press 3 to set constant" << std::endl <<
                 "p decreases current value, v increases" << std::endl;
    if( input == _jump )
        std::cout << "\033[32m";
    std::cout << "J: " << "\033[0m" << jump << std::endl;
    if( input == _c3 )
        std::cout << "\033[32m";
    std::cout << "c3: " << "\033[0m" << c3 << std::endl;
    if( input == _c2 )
        std::cout << "\033[32m";
    std::cout << "c2: " << "\033[0m" << c2 << std::endl;
    if( input == _c1 )
        std::cout << "\033[32m";
    std::cout << "c1: " << "\033[0m" << c1 << std::endl;
    if( input == _c0 )
        std::cout << "\033[32m";
    std::cout << "c0: " << "\033[0m" << c0 << std::endl;
}
