const fn = (array) => {
  let map = new Map();
  array.forEach((item) => map.set(item.id, item));

  let topKeys = array.filter((item) => !item.superId).map((item) => item.id);

  let tracksSet = [];

  // console.log('topKeys:', topKeys);

  array.forEach(
    (item) => {
      let tracks = [item.id];
      let base = item;
      while(base.superId) {
        if (base.superId === item.id) {
          throw new Error('自己父级的id指向自己的id，这会导致程序无限执行');
        }
        tracks.push(base.superId);
        base = map.get(base.superId);
      }
      tracks.reverse();
      tracksSet.push(tracks);
      // console.log('tracks:', tracks);
    }

  );

  // 已经找到自己父节点的节点
  let collectedIds = [];

  tracksSet.forEach(
    (tracks) => {
      tracks.forEach(
        (track, index) => {
          // 给每个节点增加children
          if (!Array.isArray(map.get(track).children)) {
            map.get(track).children = [];
          }
          if (!topKeys.includes(track) &&
              index - 1 >= 0 && 
              !collectedIds.includes(track)
          ) {
            map.get(tracks[index - 1]).children.push(
              map.get(track)
            );
            collectedIds.push(track);
          }
        }
      );      
    } 
  );
  return topKeys.map((key) => map.get(key));
}

module.exports = fn;