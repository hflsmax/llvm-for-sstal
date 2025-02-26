; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --version 4
; RUN: opt -S -passes=loop-rotate < %s | FileCheck %s

declare void @bar()

@threadlocalint = thread_local global i32 0, align 4

define void @foo() #0 {
; CHECK-LABEL: define void @foo(
; CHECK-SAME: ) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = tail call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @threadlocalint)
; CHECK-NEXT:    [[TMP1:%.*]] = load i32, ptr [[TMP0]], align 4
; CHECK-NEXT:    [[CMP1:%.*]] = icmp eq i32 [[TMP1]], 0
; CHECK-NEXT:    br i1 [[CMP1]], label [[COND_END_LR_PH:%.*]], label [[COND_FALSE:%.*]]
; CHECK:       cond.end.lr.ph:
; CHECK-NEXT:    br label [[COND_END:%.*]]
; CHECK:       while.cond.cond.false_crit_edge:
; CHECK-NEXT:    br label [[COND_FALSE]]
; CHECK:       cond.false:
; CHECK-NEXT:    ret void
; CHECK:       cond.end:
; CHECK-NEXT:    call void @bar()
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, ptr [[TMP0]], align 4
; CHECK-NEXT:    [[CMP:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[CMP]], label [[COND_END]], label [[WHILE_COND_COND_FALSE_CRIT_EDGE:%.*]]
;
entry:
  br label %while.cond

while.cond:
  %1 = tail call align 4 ptr @llvm.threadlocal.address.p0(ptr align 4 @threadlocalint)
  %2 = load i32, ptr %1, align 4
  %cmp = icmp eq i32 %2, 0
  br i1 %cmp, label %cond.end, label %cond.false

cond.false:
  ret void

cond.end:
  call void @bar()
  br label %while.cond
}

attributes #0 = { presplitcoroutine }
