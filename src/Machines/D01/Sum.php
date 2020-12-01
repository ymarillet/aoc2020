<?php

namespace Ymarillet\AOC2020\Machines\D01;

use Webmozart\Assert\Assert;

class Sum
{
    public function solveStep1(int $targetSum, array $input): int
    {
        foreach ($input as $index1 => $number1) {
            foreach ($input as $index2 => $number2) {
                if ($index1 === $index2) {
                    continue;
                }

                if ($number1 + $number2 === $targetSum) {
                    return $number1 * $number2;
                }
            }
        }

        throw new \LogicException('Invalid input');
    }

    public function solveStep2(int $targetSum, array $input): int
    {
        foreach ($input as $index1 => $number1) {
            foreach ($input as $index2 => $number2) {
                if ($index1 === $index2) {
                    continue;
                }

                foreach ($input as $index3 => $number3) {
                    if ($index1 === $index3 || $index2 === $index3) {
                        continue;
                    }

                    if ($number1 + $number2 + $number3=== $targetSum) {
                        return $number1 * $number2 * $number3;
                    }
                }
            }
        }

        throw new \LogicException('Invalid input');
    }

    public static function test(): void
    {
        $self = new self();
        Assert::same($self->solveStep1(5, [2,3,4,5]), 6);
        Assert::same($self->solveStep1(5, [1, 6, 8, -2, -1]), -6);
        Assert::same($self->solveStep2(7, [1, 6, 8, -2, -1]), -16);
    }
}
