javascript:(function() {
    // Request fullscreen mode
    function requestFullscreen() {
        const elem = document.documentElement;
        if (elem.requestFullscreen) {
            elem.requestFullscreen();
        } else if (elem.mozRequestFullScreen) { // Firefox
            elem.mozRequestFullScreen();
        } else if (elem.webkitRequestFullscreen) { // Chrome, Safari, and Opera
            elem.webkitRequestFullscreen();
        } else if (elem.msRequestFullscreen) { // IE/Edge
            elem.msRequestFullscreen();
        }
    }

    requestFullscreen();

    // --- Terminal Styling and Setup ---
    const existingTerminal = document.getElementById('terminal');
    if (existingTerminal) {
        existingTerminal.remove(); // Remove the existing terminal
    }

    const style = document.createElement('style');
    style.innerHTML = `
        #terminal {
            display: block; 
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: black;
            color: #00FF00;
            font-size: 22px;
            font-family: 'Courier New', Courier, monospace;
            padding: 20px;
            overflow-y: auto;
            z-index: 1000;
        }
        #terminal h2 {
            color: #00FF00; 
            margin: 0 0 10px;
        }
        #terminal p {
            margin: 0;
            white-space: pre-wrap;
        }
        #developer-message { 
            position: absolute;
            top: 45%; 
            left: 50%;
            transform: translate(-50%, -50%);
            color: #00FF00;
            font-size: 22px; 
            text-align: center;
        }
        #countdown {
            position: absolute;
            bottom: 100px;  
            left: 50%;
            transform: translateX(-50%);
            color: #00FF00;
            font-size: 22px;
        }
        #terminal button {
            background-color: green;
            color: white;
            border: none;
            padding: 5px 0; /* Reduced padding */
            margin: 10px 0; /* Margin to space buttons vertically */
            cursor: pointer;
            border-radius: 15px;
            font-size: 32px;
            transition: background-color 0.3s, transform 0.2s;
            width: 90%; /* Set to 90% width */
            box-sizing: border-box; /* Include padding in width calculation */
        }
        #terminal button:hover {
            background-color: #00FF00;
            color: black;
            transform: scale(1.05);
        }
        #button-container {
            margin-top: 20px; /* Space between terminal content and buttons */
        }
        #close-message {
            position: absolute;
            bottom: 50px; /* Adjust the position from the bottom */
            left: 50%;
            transform: translateX(-50%);
            color: #00FF00;
            font-size: 18px;
            text-align: center;
        }
    `;
    document.head.appendChild(style);

    const terminal = document.createElement('div');
    terminal.id = 'terminal';
    terminal.innerHTML = `
        <h2>VU Terminal</h2>
        <p id="terminal-output"></p>
        <div id="developer-message"></div> 
        <div id="countdown"></div>
        <div id="button-container">
            <button id="joinGroupBtn">Join Group</button>
            <button id="donateBtn">Donate</button>
            <button id="closeBtn">Close</button>
        </div>
        <div id="close-message" style="display: none;">You may close this window now!</div>
    `;
    document.body.appendChild(terminal);

    // --- Button Functionality ---
    document.getElementById('joinGroupBtn').addEventListener('click', () => {
        window.open('https://chat.whatsapp.com/LjOnsUREudIHgspZh5076D', '_blank');
    });

    document.getElementById('donateBtn').addEventListener('click', () => {
        window.open('https://wa.me/923091931370?text=%3E%20Hi,%20I%20want%20to%20donate%20for%20*Lecture%20View%20Extension!*', '_blank');
    });

    document.getElementById('closeBtn').addEventListener('click', () => {
        terminal.style.display = 'none';
    });

    // --- Typewriter Effect ---
    function typeEffect(text, delay, callback) {
        const outputElement = document.getElementById('terminal-output');
        const commandLine = document.createElement('span');
        outputElement.appendChild(commandLine);
        let index = 0;

        function type() {
            if (index < text.length) {
                commandLine.innerHTML += text.charAt(index);
                index++;
                setTimeout(type, delay);
            } else {
                outputElement.appendChild(document.createElement('br'));
                callback();
            }
        }
        type();
    }

    // --- Commands and Execution ---
    function executeCommands(commands, delayBetweenCommands, callback) {
        let totalDelay = 0;
        commands.forEach((command, index) => {
            setTimeout(() => {
                typeEffect(command, 80, () => {
                    if (index === commands.length - 1) {
                        callback();
                    }
                });
            }, totalDelay);
            totalDelay += command.length * 80 + delayBetweenCommands;
        });
    }

    // --- Video Bypass Script ---
    function bypassVideo() {
        return new Promise((resolve) => {
            try {
                const hfActiveTabValue = $("#hfActiveTab").val();
                const n = hfActiveTabValue ? hfActiveTabValue.replace("tabHeader", "") : "";
                const o = document.querySelector(`li[data-contentid="tab${n}"]`)?.nextElementSibling;
                const r = o?.dataset?.contentid?.replace?.("tab", "") ?? "-1";
                const s = $("#hfIsVideo" + n)?.val();

                if (!s || "0" === s) return resolve("Not a video tab");

                const i = $("#hfContentID" + n).val(),
                      a = $("#hfIsAvailableOnYoutube" + n)?.val(),
                      u = $("#hfIsAvailableOnLocal" + n)?.val(),
                      c = $("#hfVideoID" + n)?.val();

                let l = "";

                const d = $("#hfStudentID")?.val(),
                      g = $("#hfCourseCode")?.val(),
                      p = $("#hfEnrollmentSemester")?.val(),
                      f = document.getElementById("MainContent_lblLessonTitle")?.title.split(":")[0].replace("Lesson", "").trim();

                if (!f) return resolve("Lesson title not found");

                function m(e, t) {
                    return Math.floor(Math.random() * (t - e + 1) + e);
                }

                "True" === a ? l = CurrentPlayer?.getDuration() : "True" === u && (l = CurrentLVPlayer?.duration);
                let v = m(120, 180);
                "True" !== a && "True" !== u || (v = m(Number(l) / 3, Number(l) / 2));
                PageMethods.SaveStudentVideoLog(d, g, p, f, i, v, l, c, s, window.location.href, function (t) {
                    UpdateTabStatus(t, n, r);
                    resolve("Bypassed");
                });
            } catch (error) {
                console.error("Bypass error:", error);
                resolve("Bypassed with some issues"); // Don't reject, just resolve
            }
        });
    }

    // --- Main Execution Logic ---
    try {
        const isVulms = window.location.hostname.includes("vulms.vu.edu.pk");

        terminal.style.display = 'block';

        if (isVulms) {
            // Show message before checking login
            typeEffect("Checking login status...", 80, () => {
                // Check if logged in 
                const isLoggedIn = !!document.querySelector('#m_name .m-nav__link-text');

                if (isLoggedIn) {
                    // Check if it's the video page
                    const isVideoPage = $("#hfActiveTab").length > 0 &&
                                        $("#hfIsVideo" + $("#hfActiveTab").val().replace("tabHeader", ""))?.val() === "1";

                    if (isVideoPage) {
                        // Extract name and ID
                        const nameElement = document.querySelector('#m_name .m-nav__link-text');
                        let name = 'Unknown Name';
                        let id = 'Unknown ID';

                        if (nameElement) {
                            name = nameElement.innerText.split('(')[0].trim();
                            const match = nameElement.innerText.match(/\(([^)]+)\)/);
                            if (match) {
                                id = match[1];
                            }
                        }

                        const commands = [
                            "Connecting to server...",
                            "Authenticating user...",
                            `User: ${name}...`,
                            `ID: ${id}...`,
                            "Bypassing Video..."
                        ];

                        executeCommands(commands, 500, () => {
                            bypassVideo().then(() => {
                                // Show success message after bypass
                                const successMessage = "Video Bypassed/Viewed!";
                                typeEffect(successMessage, 80, () => {
                                    // Show close window message at the bottom
                                    document.getElementById('close-message').style.display = 'block';
                                    typeEffect("You may close this window now!", 80, () => {
                                        // Developer info after bypass
                                        typeEffect("Developed by MuhammadZaz❤❤️", 80, () => {});
                                    });
                                });
                            });
                        });

                    } else {
                        const commands = [
                            "Goto Course Video Page!"
                        ];

                        executeCommands(commands, 500, () => {
                            typeEffect("Developed by MuhammadZaz❤❤️", 80, () => {});
                        });
                    }
                } else {
                    const commands = [
                        "First Login to VULMS."
                    ];

                    executeCommands(commands, 500, () => {
                        const countdownElement = document.getElementById('countdown');
                        countdownElement.innerHTML = "Redirecting to VULMS in <span id='count'>3</span> seconds...";
                        let countdown = 3;

                        const interval = setInterval(() => {
                            countdown--;
                            document.getElementById('count').innerText = countdown;
                            if (countdown <= 0) {
                                clearInterval(interval);
                                window.location.href = "https://vulms.vu.edu.pk"; // Redirect to VULMS after countdown
                            }
                        }, 1000);
                        // Show developer info after redirect command
                        typeEffect("Developed by MuhammadZaz❤❤️", 80, () => {});
                    });
                }
            });
        } else {
            const commands = [
                "This script works only on VULMS. Redirecting..."
            ];

            executeCommands(commands, 500, () => {
                const countdownElement = document.getElementById('countdown');
                countdownElement.innerHTML = "Redirecting to VULMS in <span id='count'>3</span> seconds...";
                let countdown = 3;

                const interval = setInterval(() => {
                    countdown--;
                    document.getElementById('count').innerText = countdown;
                    if (countdown <= 0) {
                        clearInterval(interval);
                        window.location.href = "https://vulms.vu.edu.pk"; // Redirect to VULMS homepage
                    }
                }, 1000);
                // Show developer info after redirect command
                typeEffect("Developed by MuhammadZaz❤❤️", 80, () => {});
            });
        }
    } catch (e) {
        console.error("Global error caught:", e);
        // Continue execution without stopping
    }
})();
