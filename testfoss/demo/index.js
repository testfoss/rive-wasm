import RiveCanvas from "../../js/npm/canvas_advanced_single/canvas_advanced_single.mjs";

const examples = [
  { file: "ball.riv", stateMachine: "Main State Machine" },
  { file: "tape.riv", animation: "Animation 1" },
  { file: "switch_event_example.riv", stateMachine: "Main State Machine" },
  { file: "birb.riv", animation: "idle" },
];

async function loadInstance(rive, example) {
  const url = new URL(`../../wasm/examples/parcel_example/${example.file}`, import.meta.url);
  const response = await fetch(url);
  if (!response.ok) throw new Error(`Unable to load ${example.file}: HTTP ${response.status}`);
  const file = await rive.load(new Uint8Array(await response.arrayBuffer()));
  const artboard = file.defaultArtboard();
  const animation = example.animation
    ? new rive.LinearAnimationInstance(artboard.animationByName(example.animation), artboard)
    : null;
  const stateMachine = example.stateMachine
    ? new rive.StateMachineInstance(artboard.stateMachineByName(example.stateMachine), artboard)
    : null;
  return { artboard, animation, stateMachine };
}

async function main() {
  const canvas = document.querySelector("#rive-canvas");
  const status = document.querySelector("#status");
  const rive = await RiveCanvas();
  const renderer = rive.makeRenderer(canvas, true);
  const instances = await Promise.all(examples.map((example) => loadInstance(rive, example)));
  let lastTime = 0;
  let frames = 0;

  function draw(time) {
    if (!lastTime) lastTime = time;
    const elapsedSeconds = (time - lastTime) / 1000;
    lastTime = time;
    renderer.clear();

    instances.forEach(({ artboard, animation, stateMachine }, index) => {
      if (stateMachine) stateMachine.advance(elapsedSeconds);
      if (animation) {
        animation.advance(elapsedSeconds);
        animation.apply(1);
      }
      artboard.advance(elapsedSeconds);
      renderer.save();
      renderer.align(
        rive.Fit.contain,
        rive.Alignment.center,
        { minX: index * 250, minY: 0, maxX: (index + 1) * 250, maxY: 250 },
        artboard.bounds,
      );
      artboard.draw(renderer);
      renderer.restore();
    });
    renderer.flush();
    frames += 1;
    canvas.dataset.frames = String(frames);
    status.textContent = "Rive canvas-single: running";
    rive.requestAnimationFrame(draw);
  }

  rive.requestAnimationFrame(draw);
}

main().catch((error) => {
  document.querySelector("#status").textContent = `Rive demo failed: ${error.message}`;
  throw error;
});
