//
//  ViewController.m
//  Dallas Suites
//
//  Created by Mike Pesate on 10/24/14.
//  Copyright (c) 2014 ICO Group. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () {
    
    //Main View
        //Buttons
            //Room (Habitación)
    __weak IBOutlet UIButton *roomsBtn;
            //Service (Servicio)
    __weak IBOutlet UIButton *servicesBtn;
            //Register-Profile (Registrar-Perfil)
    __weak IBOutlet UIButton *registerProfileBtn;
    
    
    //PopUp (pU)
        //Text Fields
            //Username (Usuario)
    __weak IBOutlet UITextField *pUUsernameTextField;
            //Password (Contraseña)
    __weak IBOutlet UITextField *pUPasswordTextField;    
    
        //Buttons
            //LogIn Btn (Iniciar Sesión)
    __weak IBOutlet UIButton *pULogInBtn;
            //Forgot Password Btn (Recuperar Contraseña)
    __weak IBOutlet UIButton *pUForgotPasswordBtn;
            //Close PopUp Btn (Cerrar)
    __weak IBOutlet UIButton *pUCloseBtn;
    
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
