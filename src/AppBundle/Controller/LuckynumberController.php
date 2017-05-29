<?php

namespace AppBundle\Controller;

use Symfony\Bundle\FrameworkBundle\Controller\Controller;

class LuckynumberController extends Controller
{
    public function indexAction()
    {
        return $this->render('AppBundle:Luckynumber:index.html.twig', []);
    }

}
