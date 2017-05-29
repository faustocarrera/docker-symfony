<?php
use Symfony\Component\Routing\RouteCollection;
use Symfony\Component\Routing\Route;

$collection = new RouteCollection();

$collection->add('home', new Route('/', [
    '_controller' => 'AppBundle:DefaultController:index',
]));
$collection->add('index', new Route('/lucky', [
    '_controller' => 'AppBundle:Luckynumber:index',
]));

return $collection;