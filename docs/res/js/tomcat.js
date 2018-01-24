/*
* Copyright 2002-2018 The Apache Software Foundation
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

/** Author: Igal Sapir */


/** adds a live event handler akin to jQuery's on() */
function addLiveEventListeners(selector, event, handler){
    document.querySelector("body").addEventListener(
         event
        ,function(evt){
            var target = evt.target;
            while (target != null){
                // isMatch is a patch for IE 9 - 11; once support for IE11
                // is not required we can test with target.matches(selector)
                var isMatch = target.matches ? target.matches(selector) : target.msMatchesSelector(selector);
                if (isMatch){
                    handler(evt);
                    return;
                }

                target = target.parentElement;
            }
        }
        ,true
    );
}


/** toggles a class for all of the nodes that match a selector akin to jQuery's toggleClass() */
function toggleClass(selector, className){
    var nodes = document.querySelectorAll(selector);
    [].forEach.call(nodes, function(node) {
        if (node.classList.contains(className))
            node.classList.remove(className);
        else
            node.classList.add(className);
    });
}

