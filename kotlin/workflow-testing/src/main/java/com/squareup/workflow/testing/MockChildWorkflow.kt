/*
 * Copyright 2019 Square Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.squareup.workflow.testing

import com.squareup.workflow.StatefulWorkflow
import com.squareup.workflow.Workflow
import com.squareup.workflow.stateless

/**
 * A mock implementation of [Workflow] for use in tests with `testRender` and [TestRenderResult].
 *
 * Note this workflow can not actually emit any output itself. Use
 * [TestRenderResult.handleOutput] to evaluate output handlers.
 *
 * @param renderer Function that is invoked in each render pass to calculate the rendering.
 *
 * @see StatefulWorkflow.testRender
 * @see com.squareup.workflow.StatelessWorkflow.testRender
 */
class MockChildWorkflow<P, R>(private val renderer: (P) -> R) : Workflow<P, Nothing, R> {

  /**
   * Creates a [MockChildWorkflow] that will always render the same value, [rendering].
   */
  constructor(rendering: R) : this({ rendering })

  private object NullSentinal

  private var _lastSeenProps: Any? = null

  /**
   * Returns the last input value used to render this instance.
   */
  val lastSeenProps: P
    @Suppress("UNCHECKED_CAST")
    get() =
      (_lastSeenProps ?: error("Expected MockChildWorkflow to be rendered before reading input."))
          .takeUnless { it === NullSentinal } as P

  private val workflow = Workflow
      .stateless<P, Nothing, R> { input ->
        _lastSeenProps = input ?: NullSentinal
        return@stateless renderer(input)
      }
      .asStatefulWorkflow()

  override fun asStatefulWorkflow(): StatefulWorkflow<P, *, Nothing, R> = workflow
}
