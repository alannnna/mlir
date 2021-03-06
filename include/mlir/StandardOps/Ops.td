//===- Ops.td - Standard operation definitions -------------*- tablegen -*-===//
//
// Copyright 2019 The MLIR Authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =============================================================================
//
// Defines some MLIR standard operations.
//
//===----------------------------------------------------------------------===//

#ifdef STANDARD_OPS
#else
#define STANDARD_OPS

#ifdef OP_BASE
#else
include "mlir/IR/OpBase.td"
#endif // OP_BASE

// Base class for standard arithmetic operations.  Requires operands and
// results to be of the same type, but does not constrain them to specific
// types.  Individual classes will have `lhs` and `rhs` accessor to operands.
class ArithmeticOp<string mnemonic, list<OpTrait> traits = []> :
    Op<mnemonic, !listconcat(traits, [NoSideEffect, SameValueType])>,
    Results<(outs AnyType)> {

  let opName = mnemonic;

  let parser = [{
    return impl::parseBinaryOp(parser, result);
  }];

  let printer = [{
    return detail::printStandardBinaryOp(this->getOperation(), p);
  }];
}

// Base class for standard arithmetic operations on integers, vectors and
// tensors thereof.  This operation takes two operands and returns one result,
// each of these is required to be of the same type.  This type may be an
// integer scalar type, a vector whose element type is an integer type, or an
// integer tensor.  The custom assembly form of the operaton is as follows
//
//     <op>i %0, %1 : i32
class IntArithmeticOp<string mnemonic, list<OpTrait> traits = []> :
    ArithmeticOp<mnemonic, traits>,
    Arguments<(ins IntegerLike:$lhs, IntegerLike:$rhs)>;

// Base class for standard arithmetic binary operations on floats, vectors and
// tensors thereof.  This operation has two operands and returns one result,
// each of these is required to be of the same type.  This type may be a
// floating point scalar type, a vector whose element type is a floating point
// type, or a floating point tensor.  The custom assembly form of the operation
// is as follows
//
//     <op>f %0, %1 : f32
class FloatArithmeticOp<string mnemonic, list<OpTrait> traits = []> :
    ArithmeticOp<mnemonic, traits>,
    Arguments<(ins FloatLike:$lhs, FloatLike:$rhs)>;

def AddFOp : FloatArithmeticOp<"std.addf"> {
  let summary = "floating point addition operation";
  let hasConstantFolder = 0b1;
}

def AddIOp : IntArithmeticOp<"std.addi", [Commutative]> {
  let summary = "integer addition operation";
  let hasFolder = 1;
  let hasConstantFolder = 0b1;
}

def DivFOp : FloatArithmeticOp<"std.divf"> {
  let summary = "floating point division operation";
}

def DivISOp : IntArithmeticOp<"std.divis"> {
  let summary = "signed integer division operation";
  let hasConstantFolder = 0b1;
}

def DivIUOp : IntArithmeticOp<"std.diviu"> {
  let summary = "unsigned integer division operation";
  let hasConstantFolder = 0b1;
}

def MulFOp : FloatArithmeticOp<"std.mulf"> {
  let summary = "foating point multiplication operation";
  let hasConstantFolder = 0b1;
}

def MulIOp : IntArithmeticOp<"std.muli", [Commutative]> {
  let summary = "integer multiplication operation";
  let hasConstantFolder = 0b1;
  let hasFolder = 1;
}

def RemFOp : FloatArithmeticOp<"std.remf"> {
  let summary = "floating point division remainder operation";
}

def RemISOp : IntArithmeticOp<"std.remis"> {
  let summary = "signed integer division remainder operation";
  let hasConstantFolder = 0b1;
}

def RemIUOp : IntArithmeticOp<"std.remiu"> {
  let summary = "unsigned integer division remainder operation";
  let hasConstantFolder = 0b1;
}

def SubFOp : FloatArithmeticOp<"std.subf"> {
  let summary = "floating point subtraction operation";
  let hasConstantFolder = 0b1;
}

def SubIOp : IntArithmeticOp<"std.subi"> {
  let summary = "integer subtraction operation";
  let hasConstantFolder = 0b1;
  let hasCanonicalizer = 0b1;
}

#endif // STANDARD_OPS
