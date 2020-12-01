<?php

namespace Ymarillet\AOC2020\Command;

use Symfony\Component\Console\Command\Command;
use Symfony\Component\Console\Input\InputInterface;
use Symfony\Component\Console\Output\OutputInterface;
use Symfony\Component\Console\Style\SymfonyStyle;
use Ymarillet\AOC2020\Machines\D01\Sum;

final class D01 extends Command
{
    protected function configure()
    {
        $this->setName('d1');
        $this->setDescription('Executes day one machine');
    }

    protected function execute(InputInterface $input, OutputInterface $output): int
    {
        $io = new SymfonyStyle($input, $output);
        Sum::test();

        $data = explode(PHP_EOL, trim(file_get_contents(__DIR__ . '/../../data/d01.txt')));
        $io->success((new Sum())->solveStep1(2020, $data));
        $io->success((new Sum())->solveStep2(2020, $data));

        return 0;
    }
}
